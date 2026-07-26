# SAD.md

# Pass Australian Citizenship Test

## Solution Architecture Document (SAD)

### Version
2.0

### Status
Approved MVP Architecture

### Last Updated
2026-07-18

---

# 1. Purpose

This document defines the approved technical architecture for the MVP release of Pass Australian Citizenship Test.

The primary goal of this architecture is:

- Fast delivery
- Low complexity
- Minimal operational cost
- Offline-first user experience
- Validation of business idea before investing in backend infrastructure

The MVP architecture intentionally avoids cloud infrastructure, backend APIs, authentication systems, and database hosting.

The application is designed to operate entirely on the user's device.

---

# 2. Architecture Principles

## Business Principles

- Launch quickly
- Keep costs near zero
- Validate demand before scaling
- Minimize operational overhead
- Focus on content quality and user experience

---

## Technical Principles

- Frontend-only architecture
- Offline-first
- Mobile-first
- Simple deployment
- Cloud-ready for future expansion
- Maintainable codebase

---

# 3. High-Level Architecture

```text
┌─────────────────────────────┐
│       Flutter App           │
│                             │
│  Android / iOS             │
│                             │
├─────────────────────────────┤
│         Riverpod            │
├─────────────────────────────┤
│       Business Logic        │
├─────────────────────────────┤
│       Drift / SQLite        │
├─────────────────────────────┤
│      Question Content       │
│      JSON Assets            │
└─────────────────────────────┘
```

No backend services are required for MVP.

No cloud infrastructure is required for MVP.

No user authentication is required for MVP.

---

# 4. Technology Stack

## Mobile Application

### Framework

Flutter

Reason:

- Single codebase
- Android support
- iOS support
- Future web support

---

### Language

Dart

---

### State Management

Riverpod

Reason:

- Modern
- Testable
- Scalable
- Widely adopted

---

### Local Database

Drift + SQLite

Reason:

- Structured storage
- Query support
- Offline operation
- Easy migration support

---

### Content Storage

JSON files bundled with application.

---

### Optional Support

A standard external URL opens the voluntary Buy Me a Coffee page.

No store billing, purchase verification, entitlement storage, or feature gating is required.

---

# 5. Application Architecture

## Architecture Pattern

Clean Architecture

```text
Presentation Layer

Application Layer

Domain Layer

Data Layer
```

---

## Folder Structure

```text
lib/

core/

features/

├── practice/
├── categories/
├── starred/
├── exams/
├── progress/
├── analytics/
├── settings/

shared/
```

---

# 6. Content Architecture

## Question Source

Questions are bundled with the application.

Example:

```text
assets/

data/

questions.json
categories.json
references.json
exam_config.json
```

---

## Initial Import

On first launch:

```text
JSON Assets

     ↓

SQLite Database

     ↓

Application Usage
```

Questions are never loaded directly from JSON during normal application operation.

SQLite becomes the runtime data source.

---

# 7. Question Versioning

Every question must contain:

```json
{
  "questionId": 1,
  "version": 1,
  "status": "active"
}
```

---

## Purpose

Support future updates.

Support content corrections.

Support migration scripts.

---

# 8. Local Data Storage

## SQLite Tables

High-level entities:

- Questions
- Categories
- References
- User Progress
- Starred Questions
- Exam Attempts
- Exam Results
- App Settings
- Readiness Insights

Detailed schema will be defined separately in DATABASE_SCHEMA.md.

---

# 9. Practice Engine

## Purpose

Deliver immediate learning experience.

---

## Responsibilities

- Load questions
- Evaluate answers
- Display explanations
- Display references
- Track progress
- Track mistakes

All processing occurs locally.

---

# 10. Exam Engine

## Purpose

Generate and manage mock exams.

---

## Configuration Driven

Exam rules must not be hardcoded.

Configuration is stored locally.

Example:

```json
{
  "examName": "Australian Citizenship Test",
  "questionCount": 20,
  "durationMinutes": 45,
  "passMark": 75,
  "australianValuesQuestionCount": 5,
  "requireAllAustralianValuesCorrect": true
}
```

---

## Runtime Behaviour

Application reads active exam configuration.

Exam generation is performed locally.

The generator must select the configured number of Australian values questions
separately from the remaining question pool, combine the selections, and
randomize the final order. The scoring service evaluates the overall pass mark
and the Australian values requirement independently and passes an attempt only
when both conditions are satisfied.

---

## Future Flexibility

Supports:

- Different question counts
- Different durations
- Different pass marks
- Different mandatory-category counts and rules

without application code changes.

---

# 11. Progress Engine

## Purpose

Track learning progress.

---

## Metrics

- Questions attempted
- Correct answers
- Incorrect answers
- Accuracy percentage
- Category performance

All calculations occur locally.

---

# 12. Readiness Engine

## Purpose

Estimate exam readiness.

Available to every user.

---

## Inputs

- Accuracy
- Mock exam scores
- Category coverage
- Practice-attempt count for every active category
- Recent activity

---

## Output

```text
Ready For Test

82%
```

Before calculation, the engine applies an eligibility gate. If any active
category has fewer than 20 answered practice questions, it returns no numeric
score and the `Not enough data` state with per-category remaining counts.
Mock-exam answers are excluded from the eligibility count.

After calculating the normalized weighted score, the engine applies Australian
values caps using the five most recent values practice answers and the two most
recent official-style mock results. The readiness result model must expose the
uncapped score, final score, applied cap, cap reason, and next required action.

Calculation occurs locally.

No cloud services required.

---

# 13. Weak Area Analysis

## Purpose

Identify knowledge gaps.

Available to every user.

---

## Inputs

- Frequently missed questions
- Category scores
- Exam performance

---

## Output

```text
Focus Areas

Australian History
Government Structure
National Symbols
```

Calculated locally.

---

# 14. Exam History

## Purpose

Maintain historical records.

Available to every user.

---

## Stored Information

- Exam date
- Score
- Result
- Time taken
- Category breakdown

Stored locally in SQLite.

---

# 15. Optional Support Architecture

Settings opens the configured Buy Me a Coffee URL through the platform browser.

The support link has no effect on feature access or local application state.

---

# 16. Analytics

## MVP

Local analytics only.

Examples:

- Accuracy
- Readiness score
- Category performance

---

## External Analytics

Optional:

Firebase Analytics

Purpose:

- App installs
- Screen views
- User engagement

This remains optional.

---

# 17. Error Handling

## Content Load Failure

Display user-friendly error message.

---

## Database Failure

Display recovery message.

---

## External Support Link Failure

Display:

```text
The support page could not be opened.
Please try again later.
```

---

# 18. Accessibility

Support:

- Large text
- High contrast mode
- Screen reader compatibility
- Dark mode

---

# 19. Security

## Local Data

Stored in SQLite.

No sensitive government information is stored.

---

## Support Link Data

No contribution or payment data is stored by the application.

---

## Secure Storage

Use Flutter secure storage where required.

Examples:

- App preferences

---

# 20. Deployment Architecture

## Development

Local developer environment.

---

## Testing

Internal testing builds.

---

## Production

Google Play Store

Apple App Store

---

## CI/CD

Recommended:

GitHub Actions

---

# 21. Phase 2 Architecture

The following capabilities are intentionally excluded from MVP:

- User Accounts
- Authentication
- Cloud Synchronization
- Backend APIs
- AWS Infrastructure
- Firebase Backend
- Admin Portal
- Remote Question Updates
- Web Portal

These features may be introduced after product validation.

---

# 22. Future Expansion Strategy

When growth requires cloud capabilities:

```text
Flutter App
      │
      ▼
Backend API
      │
      ▼
Database
```

Potential future options:

- AWS Serverless
- Firebase
- Supabase

The MVP architecture does not prevent future migration to any of these platforms.

---

# 23. Architecture Decisions

| Area | Decision |
|--------|-----------|
| Mobile Framework | Flutter |
| Language | Dart |
| State Management | Riverpod |
| Architecture Pattern | Clean Architecture |
| Local Database | Drift + SQLite |
| Question Storage | JSON Assets |
| Runtime Storage | SQLite |
| Optional Support | External Buy Me a Coffee link |
| Analytics | Local / Optional Firebase |
| Backend | None |
| Authentication | None |
| Cloud Sync | None |
| Admin Portal | Deferred |
| Hosting Cost | $0 |

---

# 24. Architecture Approval

This document defines the approved MVP architecture for Pass Australian Citizenship Test.

The MVP shall remain frontend-only and offline-first until product validation demonstrates a need for backend infrastructure.

All future architecture decisions must preserve compatibility with potential cloud expansion while maintaining the simplicity of the MVP.
