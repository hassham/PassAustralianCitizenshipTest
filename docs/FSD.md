# FSD.md

# Pass Australian Citizenship Test

## Functional Specification Document (FSD)

### Version
2.0

### Status
Approved MVP Functional Specification

### Last Updated
2026-07-19

---

# 1. Purpose

This document defines the functional behaviour of the Pass Australian Citizenship Test mobile application.

This document answers:

> How should the application behave?

This document is intended for:

- Developers
- QA Engineers
- Designers
- AI Coding Agents

---

# 2. User Types

## Free User

A user who has not purchased Premium.

Can access:

- Practice Mode
- Category Practice
- Starred Questions
- Progress Tracking
- Untimed Mock Exams

---

## Premium User

A user who has purchased Premium.

Can access everything available to Free users plus:

- Timed Mock Exams
- Readiness Score
- Weak Area Analysis
- Exam History
- Advanced Analytics

---

# 3. Application Navigation

Bottom Navigation:

```text
Home
Practice
Mock Exams
Progress
Settings
```

Additional Screens:

```text
Categories
Starred Questions
Premium
Exam Results
Question Review
```

---

# 4. Home Screen

## Purpose

Provide a dashboard and entry point.

---

## Display

### Welcome Section

```text
Pass Australian Citizenship Test
```

---

### Quick Statistics

Display:

- Questions Attempted
- Accuracy %
- Questions Starred

---

### Continue Learning

Shown when:

- User has active practice session

Display:

```text
Continue Learning
```

---

### Quick Actions

Buttons:

```text
Practice Questions
Mock Exam
Starred Questions
```

---

### Premium Banner

Shown to non-premium users.

Example:

```text
Unlock Timed Exams
```

---

# 5. Practice Mode

## Purpose

Allow users to learn through immediate feedback.

---

## Start Practice

User can choose:

```text
All Questions

Single Category

Multiple Categories

Starred Questions
```

---

## Question Screen

Display:

- Question Number
- Question Text
- Four Options
- Category
- Difficulty
- Star Icon

---

## Option Selection

User selects one answer.

Once selected:

### Disable Further Changes

Answer becomes final.

---

### Immediate Feedback

Display:

```text
Correct
```

or

```text
Incorrect
```

---

### Highlighting

Correct Answer:

Green

Incorrect Selection:

Red

---

### Display Explanation

Show:

- Explanation
- Why Correct Answer Is Correct
- Why Incorrect Answers Are Wrong

---

### Display Official Reference

Show:

- Book Title
- Chapter
- Section
- Page

---

### External Reference

If official URL exists:

Display:

```text
Open Official Source
```

---

## Navigation

Buttons:

```text
Previous

Next
```

---

## Session Persistence

If app closes:

- Current question retained
- Session restored on next launch

---

# 6. Category Practice

## Purpose

Focused learning.

---

## Available Categories

Loaded from local database.

Not hardcoded.

---

## User Actions

User can:

- Select one category
- Select multiple categories
- Select all categories

---

## Behaviour

Uses same workflow as Practice Mode.

---

# 7. Starred Questions

## Add Star

User taps star icon.

Question added to starred list.

---

## Remove Star

User taps filled star.

Question removed.

---

## Starred Question Screen

Display:

- Question
- Category
- Difficulty

---

## Filters

Support:

- Category
- Difficulty

---

## Practice Starred Questions

User may launch practice mode using only starred questions.

---

## Archived Questions

If a starred question becomes archived after an app update:

Display:

```text
This question is no longer part of the active question bank.
```

---

# 8. Mock Exams

## Purpose

Simulate citizenship tests.

---

## Exam Configuration

Loaded from local configuration.

Configurable:

- Question Count
- Duration
- Pass Mark
- Mandatory Rules

---

## Exam Creation

Application randomly selects questions based on configuration rules.

---

# 9. Free Mock Exams

## Behaviour

Exam uses:

- Same layout as Premium
- Same questions
- Same scoring

---

## Limitations

No timer.

No readiness score.

No weak-area analysis.

No exam-history screen.

---

## Navigation

User may:

- Move forward
- Move backward
- Review unanswered questions

---

## Submission

User taps:

```text
Submit Exam
```

---

## Confirmation

Display:

```text
Are you sure you want to submit?
```

---

## Results

Display:

- Score
- Pass/Fail
- Correct Answers
- Incorrect Answers

---

## Review

User may review all questions.

---

# 10. Premium Timed Exams

## Behaviour

Uses exam configuration.

---

## Timer

Timer begins immediately.

---

## Timer Display

Always visible.

---

## Pause

Not available.

---

## Background Behaviour

Timer continues running.

---

## Application Restart

Exam restored.

Remaining time recalculated using:

```text
Start Time
+
Configured Duration
-
Current Time
```

---

## Timeout

Exam automatically submits.

---

## Timeout Warning

Display warnings:

```text
10 Minutes Remaining

5 Minutes Remaining

1 Minute Remaining
```

---

## Results

Display:

- Score
- Pass/Fail
- Readiness Score
- Weak Areas

---

# 11. Exam Review

## Purpose

Allow users to understand mistakes.

---

## Display

For each question:

- User Answer
- Correct Answer
- Explanation
- Reference

---

## Review Navigation

User can move:

- Next
- Previous

---

# 12. Progress Screen

## Purpose

Show learning performance.

---

## Statistics

Display:

- Questions Attempted
- Correct Answers
- Incorrect Answers
- Accuracy %

---

## Category Performance

Display performance by category.

---

## Activity Summary

Display:

- Total Practice Sessions
- Total Exam Attempts
- Questions Completed

---

# 13. Readiness Score

## Premium Feature

Purpose:

Estimate preparation level.

---

## Inputs

- Accuracy
- Category Coverage
- Mock Exam Performance
- Consistency

---

## Output

Range:

```text
0 - 100
```

---

## Labels

```text
0-49
Needs Preparation

50-69
Moderate Readiness

70-84
Likely Ready

85-100
Highly Ready
```

---

## Formula Ownership

Formula shall be documented separately.

The UI must consume the calculated score.

---

# 14. Weak Area Analysis

## Premium Feature

Purpose:

Identify weakest areas.

---

## Analysis Sources

- Category Scores
- Repeated Mistakes
- Mock Exam Results

---

## Output

Display ranked list.

Example:

```text
1. Australian History

2. Government Structure

3. National Symbols
```

---

# 15. Exam History

## Premium Feature

Display:

- Date
- Score
- Pass/Fail
- Time Taken

---

## Detail View

User may open any previous attempt.

---

# 16. Premium Purchase Flow

## Purchase Entry Points

- Premium Screen
- Mock Exam Screen
- Readiness Screen

---

## Purchase Process

User taps:

```text
Unlock Premium
```

Store purchase flow begins.

---

## Successful Purchase

Display:

```text
Premium Activated
```

---

## Cancelled Purchase

Display:

```text
Purchase Cancelled
```

---

## Failed Purchase

Display:

```text
Purchase Failed
```

---

## Restore Purchases

Available through Settings.

---

## Refunded Purchase

If store revokes purchase:

Premium access removed.

---

# 17. Settings Screen

## Appearance

- Light Mode
- Dark Mode
- System Default

---

## Accessibility

- Text Size
- High Contrast

---

## Learning

- Shuffle Questions
- Shuffle Answers

---

## Data

- Reset Progress
- Clear Starred Questions
- Reset Application Data

---

## Purchases

- Restore Purchases

---

## Information

- Privacy Policy
- Terms of Use
- Disclaimer

---

# 18. Reset Behaviour

## Reset Progress

Deletes:

- Progress
- Attempts
- Exam History

Preserves:

- Stars
- Premium

---

## Clear Starred Questions

Deletes only stars.

---

## Reset Application Data

Deletes all local user data.

Premium restored using store purchase restoration.

---

# 19. Error Handling

## Database Failure

Display:

```text
Unable to load data.
Please restart the application.
```

---

## Corrupt Content

Display:

```text
Question content could not be loaded.
```

---

## Purchase Service Unavailable

Display:

```text
Store services are currently unavailable.
```

---

## Exam Recovery Failure

Display:

```text
Exam session could not be restored.
```

---

# 20. Accessibility

Support:

- Large Fonts
- High Contrast
- Screen Readers
- Dark Mode

---

# 21. Privacy

No user account required.

No personal citizenship information collected.

Analytics must be disclosed in Privacy Policy if enabled.

---

# 22. Disclaimer

Application is not affiliated with the Australian Government.

Official references are provided for educational purposes only.

---

# 23. Out of Scope

Not included in MVP:

- User Accounts
- Cloud Sync
- Backend APIs
- Admin Portal
- Web Portal
- Chatbot
- Community Features
- Multi-language Support
- Remote Question Updates

---

# 24. Approval

This document defines the approved functional behaviour for the MVP release of Pass Australian Citizenship Test.

All implementation, testing, UI design and database behaviour must align with this specification.