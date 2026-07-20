# Implementation Details & Technical Specifications

## Pass Australian Citizenship Test

### Technical Specification for Development

**Version:** 2.0

**Last Updated:** 2026-07-20

---

# 1. Session Persistence

## 1.1 Practice Session Persistence

When a user starts a practice session:

```
Session Flow:
1. Create new row in user_practice_sessions table
2. Generate unique sessionId (UUID)
3. Populate: sessionType, selectedCategories, totalQuestions
4. Set questionsAttempted = 0, currentQuestionIndex = 0
5. Generate full question list (randomized based on filters)
6. Persist to database
```

---

### Persistence During Use

After each question answered:

```
1. Insert row into user_question_attempts (questionId, optionId, isCorrect, etc.)
2. Update user_practice_sessions (questionsAttempted, correctAnswers, currentQuestionIndex)
3. Save to database immediately (not cached in memory alone)
```

---

### Session Restoration on App Close

When app is backgrounded or closed:

```
Current State Stored:
- user_practice_sessions.currentQuestionIndex
- user_practice_sessions.currentQuestionId
- user_practice_sessions.questionsAttempted
- user_practice_sessions.correctAnswers

On App Restart:
1. Query user_practice_sessions WHERE isCompleted = 0
2. Check if any active sessions exist
3. If yes:
   - Load user_practice_sessions record
   - Load full question list from database
   - Restore to: user_practice_sessions.currentQuestionIndex
   - Display: "Continue Learning?" prompt
   - User can continue or start new session

If user selects "Continue":
   - Retrieve currentQuestionId from database
   - Load that question screen
   - Preserve all previous answers
```

---

### Session Timeout

```
Active Session Definition:
- Any session with isCompleted = 0

Session Stale Timeout (Future Feature):
- Currently: No timeout implemented
- Sessions persist indefinitely until completed or user starts new session

For MVP:
- Allow sessions to remain open for weeks if needed
- User can always "Start New Session" if they want fresh start
```

---

## 1.2 Exam Session Persistence

Mock exam persistence works similarly but with additional state:

```
Exam Session State Stored in exam_attempts table:
- examAttemptId (primary key)
- selectedQuestions (JSON array of questionIds)
- currentQuestionIndex
- currentQuestionId
- questionsAnswered
- startedAt
- isPremiumTimed (boolean)
- remainingTimeSeconds (for timed exams)
- backgroundedAt (timestamp when backgrounded)
- isCompleted (boolean)

Exam Session State Stored in exam_attempt_answers table:
- For each attempted question: answer details
```

---

### Timer Persistence for Timed Exams

When user backgrounds a timed exam:

```
On Background:
1. Record backgroundedAt = current_timestamp
2. Save remaining time to exam_attempts.remainingTimeSeconds
3. Save exam state to database

On App Resume:
1. Query exam_attempts WHERE isCompleted = 0 AND isPremiumTimed = 1
2. Calculate elapsed time = current_time - backgroundedAt
3. Recalculate remaining time = remainingTimeSeconds - elapsed_time
4. If remaining time <= 0:
   - Auto-submit exam
   - Mark as completed
   - Display results
5. Else:
   - Restore to current question
   - Resume timer with updated remaining time
```

---

## 1.3 Starred Questions Persistence

```
Real-time persistence:
- When user taps star icon
- Immediately insert into user_starred_questions table
- Mark isActive = 1

When user unstar:
- Update isActive = 0 (soft delete)
- Or delete row (hard delete)
- Restore view immediately
```

---

# 2. Timer Edge Cases & Handling

## 2.1 Timer Accuracy

Timer is based on elapsed real-world time, not question count.

```
Timer Implementation:
- Use SystemTime or platform equivalent (DateTime.now in Flutter)
- Not dependent on frame rate or app refresh
- Start: startedAt timestamp stored in exam_attempts
- Recalculate remaining time on every screen update

Remaining Time Calculation:
remainingTime = (durationMinutes * 60) - (now - startedAt)
```

---

## 2.2 Device Time Change During Exam

```
Scenario: User changes device clock backward during exam

Detection:
1. On each timer update, check: newTimestamp < previousTimestamp
2. If detected:
   - Lock timer to current remaining time
   - Prevent further decrements
   - Log warning (for debugging)

Behavior:
- User cannot gain extra time by changing device clock
- Timer effectively freezes at moment of detection
- User cannot proceed with exam after time lock
```

---

## 2.3 Timer Expiry

```
When remainingTime <= 0:
1. Auto-submit exam immediately
2. Mark exam_attempts.isCompleted = 1
3. Mark exam_attempts.submittedAt = current_timestamp
4. Set any unanswered questions to isCorrect = NULL
5. Calculate final score
6. Display results screen with message:
   "Time's up! Your exam has been automatically submitted."
```

---

## 2.4 Network Timeout (Not Applicable MVP)

```
MVP: No network calls, so no network timeout handling needed

Future: When backend is introduced:
- Exam state synced periodically to server
- Connection loss does not affect local exam state
- Retry sync on reconnect
```

---

## 2.5 Background Timer

```
Timer continues while app backgrounded:
- System time used, not app-level timer
- When app resumes, elapsed time calculated from system timestamps

Pseudo-code:
backgroundedAt = timestamp
// App in background for 5 minutes
resumedAt = timestamp
elapsedInBackground = resumedAt - backgroundedAt
remainingTime = previousRemainingTime - elapsedInBackground
```

---

# 3. Error Handling Strategy

## 3.1 Database Errors

```
Error: Corrupted SQLite database

Handling:
1. Try to open database
2. If OPEN fails:
   - Delete corrupted database file
   - Recreate empty database
   - Re-import JSON assets
   - Display message: "App data was refreshed. Restart the app."

Logging:
- Log error details to local file for debugging
- Preserve error logs for 30 days
```

---

### Error: Database Locked

```
Scenario: Multiple threads accessing database simultaneously

Handling:
1. Retry up to 3 times with 100ms delay between retries
2. If still locked after 3 retries:
   - Log warning
   - Gracefully fall back
   - Display: "Unable to save progress. Please try again."

Prevention:
- Use database connection pooling
- Single write at a time (queue writes if necessary)
```

---

### Error: Out of Disk Space

```
Handling:
1. Check available disk space before saving large data
2. If < 50MB available:
   - Warn user: "Low disk space. Performance may be affected."
3. If < 10MB available:
   - Block premium features
   - Display: "Insufficient disk space for features. Free up space."

Current Usage Estimation:
- Base app: ~50MB
- Question database: ~80MB
- User data/cache: ~10MB
- Recommended: 200MB minimum available
```

---

## 3.2 Content Import Errors

```
Error: Malformed JSON in questions.json

Handling:
1. Use JSON parser with error context
2. Log line number and error details
3. Skip malformed records (if partial import is acceptable)
4. Display warning: "Some questions could not be loaded. Using available content."

Validation:
- Validate all questions on import
- Check: exactly 4 options, 1 correct answer, explanation exists
- If validation fails, reject entire import and use fallback
```

---

### Error: Missing JSON Assets

```
Handling:
1. Check asset bundle for required files on app start
2. If missing:
   - Block practice/exam features
   - Display: "Content not available. Please reinstall the app."
   - Allow Settings/About screens to function

Files Required:
- questions.json
- categories.json
- references.json
- exam_config.json
```

---

## 3.3 In-App Purchase Errors

```
Error: Purchase verification fails

Handling:
1. Log full error response
2. Display to user: "Purchase verification failed. Please try again."
3. Allow user to retry "Restore Purchases"
4. If retry fails, display: "Contact support if issue persists."

Error: Platform API not available

Handling:
1. iOS: Apple In-App Purchase API unavailable
2. Android: Google Play Billing API unavailable
3. Block premium features
4. Display: "In-app purchases unavailable. Check platform settings."
```

---

## 3.4 UI Error States

```
Generic Error Handling:
- All errors caught in try-catch blocks
- Display user-friendly error message (not stack traces)
- Log full technical error for debugging
- Provide "Retry" button where applicable
- Allow user to continue with unaffected features

Error Message Format:
- Title: Clear problem statement
- Body: What user can do
- Button: "Retry", "Continue", or "Go Home"
```

---

## 3.5 Logging

```
Log Levels:
- DEBUG: Verbose app flow, metrics calculations
- INFO: Session start/end, feature usage, purchase events
- WARN: Non-critical issues, retries
- ERROR: Failures, exceptions, data loss risks

Log Storage:
- Local file: ~/.app_logs/
- Retention: 30 days, then delete
- Size: Cap at 100MB total (rotate files)

Sensitive Data:
- DO NOT log: Purchase tokens, device IDs, personal user data
- OK to log: Features used, app version, timestamp, error types
```

---

# 4. Accessibility Considerations

## 4.1 Screen Reader Support

```
Requirements:
- All UI elements have semantic labels
- Button purposes clear from labels alone
- Form fields clearly associated with labels
- Icons have alt text describing function

Implementation:
Flutter:
- Use Semantics widget
- Set label, enabled, enabled, tooltip
- Set enableSemantics = true globally

Example:
Semantics(
  label: 'Star this question for later review',
  enabled: true,
  onTap: () => starQuestion(),
  child: IconButton(icon: Icon(Icons.star))
)
```

---

## 4.2 Text Sizing

```
Supported Sizes:
- Small: 100% (default)
- Medium: 120%
- Large: 150%
- Extra Large: 200%

Implementation:
- Respect system text size setting
- Use MediaQuery.of(context).textScaleFactor
- Test layouts at 200% text size
- Avoid hardcoded fixed sizes
```

---

## 4.3 Color Contrast

```
WCAG AA Compliance:
- Minimum contrast ratio: 4.5:1 for normal text
- Minimum contrast ratio: 3:1 for large text
- Don't rely on color alone to convey information

Correct Answer Display:
- Use: Green background + checkmark icon + "Correct" text
- Not: Green background only

Incorrect Answer Display:
- Use: Red background + X icon + "Incorrect" text
- Not: Red background only
```

---

## 4.4 Focus Navigation

```
Keyboard Navigation:
- All interactive elements focusable via Tab/Shift+Tab
- Visual focus indicator on all buttons
- Logical tab order (top-to-bottom, left-to-right)

Quiz Navigation:
- Can navigate between options with arrow keys
- Can submit answer with Enter
- Tab moves to Next button
```

---

## 4.5 Vibration & Motion

```
Haptic Feedback:
- Optional (respect user preferences)
- Used for: answer submission, timer warning
- Settable in preferences

Motion & Animations:
- Provide option to reduce motion (respect system setting)
- Don't require animation to understand content
- Test with animations disabled
```

---

# 5. Performance Targets

## 5.1 App Launch Time

```
Target: < 3 seconds from app icon tap to home screen visible

Breakdown:
- App startup: < 1 second
- Database initialization: < 1 second
- Load home screen data: < 1 second

Optimization:
- Lazy load features
- Pre-fetch home screen data during startup
- Background calculate readiness score after home screen loads
```

---

## 5.2 Question Load Time

```
Target: < 500ms from tap to question fully displayed

Includes:
- Load question text
- Load 4 options
- Load explanation (not displayed yet)
- Load reference

Optimization:
- Pre-load next question in background
- Cache frequently accessed questions
- Load explanation on-demand when user taps "Show Explanation"
```

---

## 5.3 Database Query Performance

```
Target: All queries complete in < 100ms

Common Queries:
- Get random 20 questions: < 50ms
- Get user accuracy by category: < 50ms
- Get exam history: < 100ms
- Insert practice attempt: < 50ms

Optimization:
- Proper indexing (specified in DATABASE_SCHEMA.md)
- Limit result sets (pagination for large lists)
- Cache frequently accessed data
```

---

## 5.4 Memory Usage

```
Target: Average < 150MB RAM at runtime

Breakdown:
- Base app: ~80MB
- Loaded questions (current session): ~20MB
- UI components: ~30MB
- Cache & buffers: ~20MB

Optimization:
- Don't load entire question database into memory
- Dispose of unused screens/widgets
- Use object pooling for frequently created objects
- Clear caches periodically
```

---

## 5.5 Battery Usage

```
Target: 1 hour of active use = < 15% battery drain

Optimization:
- Minimize CPU usage during idle
- Use efficient timers (not spinning loops)
- Batch database writes
- Disable background sync in MVP

Timer Behavior:
- Use platform timer (not app-level polling)
- CPU should sleep when app backgrounded
```

---

## 5.6 Network Usage (Future)

```
Not applicable for MVP (offline-first)

Future consideration when backend introduced:
- Minimize data transferred per sync
- Use compression for large payloads
- Only sync when on WiFi (if user preference)
```

---

# 6. Content Management

## 6.1 Initial Content Loading

On first app launch:

```
1. Check if questions_db already exists (size > 0)
2. If not:
   - Show "Initializing content..." screen
   - Read questions.json from assets (80MB)
   - Parse JSON
   - Validate all records
   - Insert into SQLite database (batch insert)
   - Duration: ~10-30 seconds (depends on device)
3. Mark app_settings: last_content_update = today
4. Show home screen
```

---

## 6.2 Content Updates (Future)

```
MVP: Content updates require app update

Future (Post-MVP):
- Download new questions JSON
- Merge with existing database
- Use content_versions table to track updates
- Migrate data if schema changes
```

---

## 6.3 Question Versioning

Each question has:

```
{
  "questionId": 1,
  "version": 1,
  "status": "active"
}

Archival Process:
- If question is removed: status = "archived"
- User's previous answers retained
- Starred archived questions show: "This question is no longer part of the active question bank"
- Archived questions excluded from new practice/exams
```

---

# 7. Testing Requirements

## 7.1 Unit Test Coverage

```
Target: 80% code coverage

Priority:
- Readiness score calculation (all branches)
- Weak area analysis logic
- Timer calculations
- Score calculations
- Database queries
```

---

## 7.2 Integration Tests

```
Key Flows:
1. Complete practice session start to finish
2. Complete timed exam with timer running down
3. Session persistence and restoration
4. Premium purchase and feature unlock
5. Weak area analysis generation
```

---

## 7.3 Manual Testing Scenarios

```
1. Device rotation during quiz
2. Timer + backgrounding
3. Out of memory condition
4. Corrupted database recovery
5. Accessibility with screen reader
6. UI at 200% text size
```

---

# 8. Deployment & Release

## 8.1 Version Format

```
Format: X.Y.Z (Semantic Versioning)

X = Major version (breaking changes, major features)
Y = Minor version (new features, backward compatible)
Z = Patch version (bug fixes)

Examples:
1.0.0 - MVP Release
1.1.0 - New feature (e.g., timed exam improvements)
1.0.1 - Bug fix
2.0.0 - Major redesign or backend introduction
```

---

## 8.2 Release Checklist

```
Before Release:
- [ ] All tests passing (unit, integration, manual)
- [ ] No critical bugs open
- [ ] Performance targets met
- [ ] Accessibility audit passed
- [ ] Content reviewed for accuracy
- [ ] Privacy policy finalized
- [ ] Store listings prepared (screenshots, descriptions)
- [ ] Build tested on real devices
```

---

## 8.3 Rollback Plan

```
If critical bug found after release:
1. Issue hotfix build
2. Increment Z version (e.g., 1.0.1)
3. Push to stores
4. Notify users if applicable

Critical Issues Requiring Rollback:
- App crashes on startup for > 10% users
- Data loss
- Security vulnerability
- Payment failures
```

---
