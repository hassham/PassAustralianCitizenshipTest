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

### Purchases

Native Store Purchases

Android:

- Google Play Billing

iOS:

- Apple In-App Purchases

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
├── premium/
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
- Premium Entitlements

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
  "passMark": 75
}
```

---

## Runtime Behaviour

Application reads active exam configuration.

Exam generation is performed locally.

---

## Future Flexibility

Supports:

- Different question counts
- Different durations
- Different pass marks

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

Premium Feature.

---

## Inputs

- Accuracy
- Mock exam scores
- Category coverage
- Recent activity

---

## Output

```text
Ready For Test

82%
```

Calculation occurs locally.

No cloud services required.

---

# 13. Weak Area Analysis

## Purpose

Identify knowledge gaps.

Premium Feature.

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

Premium Feature.

---

## Stored Information

- Exam date
- Score
- Result
- Time taken
- Category breakdown

Stored locally in SQLite.

---

# 15. Premium Purchase Architecture

## Android

Google Play Billing

---

## iOS

Apple In-App Purchases

---

## Verification

MVP relies on platform purchase verification and restore purchase functionality.

No custom backend verification is required for MVP.

---

## Future Enhancement

Server-side purchase validation may be introduced in a future release.

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

## Purchase Failure

Display:

```text
Purchase could not be completed.
Please try again.
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

## Purchase Data

Managed by Apple and Google platforms.

---

## Secure Storage

Use Flutter secure storage where required.

Examples:

- Purchase metadata
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
| Purchases | Google Billing + Apple IAP |
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