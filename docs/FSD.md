# FSD.md

# Pass Australian Citizenship Test

## Functional Specification Document (FSD)

### Version
2.1

### Status
Approved MVP Functional Specification

### Last Updated
2026-07-25

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

# 2. User Access

## App User

Every user has the same feature access.

Can access:

- Practice Mode
- Category Practice
- Starred Questions
- Progress Tracking
- Untimed Mock Exams
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

### Readiness Summary

Display the current readiness score or the next recommended action.

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
- Australian Values Question Count
- Require All Australian Values Answers Correct

---

## Exam Creation

For the standard 20-question configuration, the application selects:

- Exactly 5 questions from Part 4: Australian values
- 15 questions from Parts 1-3

The complete question list is randomly ordered. Mock exams do not group
questions by category or reveal a category sequence during the attempt.

---

## Pass/Fail Rules

An exam passes only when both conditions are true:

- Overall score is at least 15/20 (75%)
- Australian values score is exactly 5/5 (100%)

Failing either condition produces a failed result. For example, 19/20 is a
failure when the incorrect answer is an Australian values question.

Results must separately display:

- Overall score and threshold
- Australian values score and 5/5 requirement
- The specific condition or conditions that caused a failure

---

# 9. Untimed Mock Exams

## Behaviour

Exam uses:

- Same question and review layout as timed exams
- Same questions
- Same scoring

---

## Limitations

No timer.

Readiness, weak-area analysis, and exam history remain available.

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

# 10. Timed Mock Exams

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

## Minimum Data Requirement

The readiness score is hidden until the user has answered at least 20 practice
questions in every active category.

Before the requirement is met, display:

```text
Not enough data
```

The screen should show progress for each incomplete category, including how
many more practice questions are needed. Mock-exam answers do not count toward
the 20-question-per-category requirement.

---

## Australian Values Readiness Rules

After the minimum-data requirement is met:

- Fewer than 5/5 correct in the five most recent Australian values practice
  answers caps readiness at 69.
- Perfect recent values practice but no qualifying recent mock exam caps
  readiness at 79.
- One most-recent qualifying mock exam caps readiness at 89.
- Only two consecutive qualifying mock exams allow readiness from 90–100.

A qualifying mock exam passes both official requirements: at least 75% overall
and exactly 5/5 Australian values.

The readiness UI must explain an applied cap and recommend the specific action
needed to reach the next readiness band.

---

## Formula Ownership

Formula shall be documented separately.

The UI must consume the calculated score.

---

# 14. Weak Area Analysis

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

Display:

- Date
- Score
- Pass/Fail
- Time Taken

---

## Detail View

User may open any previous attempt.

---

# 16. Optional Support Link

Settings may display:

```text
Support this app
Buy Me a Coffee
```

The link opens in the external browser. Supporting the app is optional and does not unlock features.

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

## Optional Support

- Support this app

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
- App settings

---

## Clear Starred Questions

Deletes only stars.

---

## Reset Application Data

Deletes all local user data.

All study features remain available after reset.

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

## Support Page Unavailable

Display:

```text
The support page could not be opened. Please try again later.
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
