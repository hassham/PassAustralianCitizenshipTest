# PRD.md

# Pass Australian Citizenship Test

## Product Requirements Document (PRD)

### Version
2.0

### Status
Approved MVP Scope

### Last Updated
2026-07-19

---

# 1. Product Overview

## Product Name

Pass Australian Citizenship Test

---

## Vision

Become the most trusted and realistic Australian Citizenship Test preparation app available on mobile devices.

The application should help users understand the material rather than simply memorize answers.

---

## Mission

Provide a modern, distraction-free, offline-first study experience that prepares users to confidently pass the Australian Citizenship Test.

---

# 2. Problem Statement

Current citizenship test applications commonly suffer from:

- Excessive advertisements
- Outdated interfaces
- Poor user experience
- Limited question banks
- Weak explanations
- Lack of official references
- No meaningful progress tracking
- Unrealistic exam simulations

Many users end up memorizing answers without understanding the concepts behind them.

---

# 3. Business Goals

## Initial Goals

- 1,000+ downloads within six months
- 4.5+ app store rating
- 10% premium conversion rate
- Establish trust within migration and citizenship communities

---

## Long-Term Goals

- Become the leading citizenship preparation app
- Expand into additional government test preparation products
- Expand into web platform
- Introduce cloud synchronization

---

# 4. Target Audience

## Primary Users

- Australian Permanent Residents preparing for citizenship
- First-time citizenship applicants
- Users preparing for a re-attempt

---

## Secondary Users

- Migration consultants
- Community centers
- Citizenship preparation trainers

---

# 5. Unique Selling Proposition

## Core Positioning

The most realistic Australian Citizenship Test preparation app with detailed explanations, official references and exam simulation.

---

## Differentiators

- Clean user experience
- No advertisements
- Offline-first
- Detailed answer explanations
- Official booklet references
- Why correct answers are correct
- Why incorrect answers are wrong
- Starred question revision
- Readiness scoring
- Weak-area identification
- Realistic timed exam simulation

---

# 6. Platforms

## MVP

### Mobile

- Android
- iOS

---

## Deferred

### Web Application

Future release only.

Not part of MVP.

---

# 7. Product Scope

## Included In MVP

### Practice Mode

Users can practice unlimited questions.

Features:

- Immediate feedback
- Correct answer display
- Explanations
- Official references

---

### Study By Category

Users can practice:

- Single category
- Multiple categories
- Entire question bank

---

### Starred Questions

Users can:

- Bookmark questions
- Remove bookmarks
- Review only bookmarked questions

---

### Progress Tracking

Users can view:

- Questions attempted
- Accuracy percentage
- Category performance
- Learning progress

---

### Free Mock Exams

Users can:

- Complete mock exams
- Review answers
- View score
- View pass/fail result

Limitations:

- No timer
- No readiness score
- No weak-area analysis
- No exam history screen

---

### Premium Timed Mock Exams

Users can:

- Complete realistic timed exams
- Receive readiness score
- Receive weak-area analysis
- Access exam history
- Access detailed analytics

---

### Readiness Score

Provides a confidence indicator showing how prepared the user is for the official test.

---

### Weak Area Analysis

Identifies:

- Low-scoring categories
- Frequently missed topics
- Knowledge gaps

---

### Exam History

Stores historical mock exam performance.

Premium feature.

---

### Official References

Every question includes:

- Book reference
- Chapter reference
- Section reference
- Page reference where available

---

# 8. Question Bank Requirements

## Initial Content Target

Minimum:

500 Questions

Target:

500–1000 Questions

---

## Source Material

Australian Citizenship:

"Our Common Bond"

Questions must be original.

Questions must not be copied from competitor applications.

---

## Question Structure

Every question must contain:

- Question text
- Four answer options
- Correct answer
- Explanation
- Why correct answer is correct
- Why incorrect answers are wrong
- Official reference
- Difficulty level
- Category
- Topic

---

## Difficulty Levels

- Easy
- Medium
- Hard

---

# 9. Monetization Strategy

## Premium Model

One-time purchase.

No subscription in MVP.

---

## Premium Features

- Timed exams
- Readiness score
- Weak-area analysis
- Exam history
- Detailed analytics

---

## Pricing

Target range:

AUD $4.99 – $9.99

Final pricing to be determined before release.

---

## Purchase Restoration

Users must be able to restore purchases through Apple and Google mechanisms.

---

## Cross Platform Purchase Limitation

Purchases are controlled by Apple and Google.

A purchase made on Android is not automatically available on iOS and vice versa.

Cross-platform entitlement synchronization is deferred until user accounts and backend infrastructure are introduced.

---

# 10. Advertising Strategy

## MVP Decision

No advertisements.

---

## Rationale

The product aims to differentiate itself from existing ad-heavy competitors.

Learning experience takes priority over advertising revenue.

---

## Future Consideration

Advertisements may be evaluated after product validation.

If introduced:

- No ads during practice
- No ads during exams
- No ads during answer review

Permitted locations:

- Home screen
- Results screen
- Progress screen

---

# 11. Free vs Premium

## Free Users

Access to:

- Practice mode
- Category practice
- Starred questions
- Progress tracking
- Untimed mock exams

---

## Premium Users

Access to:

- Timed exams
- Readiness score
- Weak-area analysis
- Exam history
- Advanced analytics

---

# 12. Exam Rules

## Configuration Driven

Exam rules must not be hardcoded.

The application reads exam settings from local configuration.

---

## Configurable Values

- Question count
- Duration
- Pass mark

---

## MVP Limitation

Configuration is bundled with the application.

Changes to official test rules require an application update.

Remote configuration is out of scope for MVP.

---

# 13. Timer Behaviour

## Premium Timed Exams

Timer is based on elapsed real-world time.

---

## Background Behaviour

If the user backgrounds the application:

- Timer continues running

---

## Application Restart

If the application is closed:

- Exam state is restored
- Remaining time is recalculated

---

## Time Expiry

When time expires:

- Exam automatically submits

---

## Pause Functionality

No pause button in MVP.

This maintains realistic exam simulation.

---

# 14. Free Exam Result Retention

Free users may review exam results immediately after completion.

The application may internally retain free exam results for future premium upgrades.

However:

Exam History screen remains a Premium feature.

---

# 15. Official References

## Display

Each question must display:

- Book title
- Chapter
- Section
- Page

---

## External Link

Where available, users may open the official source.

---

## MVP Behaviour

The application should not rely on deep-linking into specific PDF pages.

The reference itself must remain visible inside the app.

---

# 16. Privacy Requirements

## Data Storage

All user data remains on the device.

No user account is required.

---

## Analytics

Analytics are optional.

If analytics are implemented:

- No personal citizenship information may be collected
- Privacy policy must disclose analytics usage

---

## User Controls

Users must be able to:

- Reset progress
- Clear starred questions
- Reset local data

---

# 17. Disclaimer

The application is:

- Not affiliated with
- Not endorsed by
- Not approved by

the Australian Government.

Official references are provided solely for educational purposes.

---

# 18. Out of Scope

The following are explicitly excluded from MVP:

- User accounts
- Authentication
- Cloud synchronization
- Backend APIs
- Admin portal
- Web application
- AI chatbot
- Discussion forums
- Community features
- Social sharing platform
- Multi-language support
- Remote content updates
- Leaderboards
- Corporate licensing

---

# 19. Future Roadmap

## Phase 2

Potential additions:

- User accounts
- Cloud backup
- Device synchronization
- Web application
- Remote question updates
- Admin portal

---

## Phase 3

Potential additions:

- Additional citizenship products
- Driver knowledge tests
- PTE preparation
- IELTS preparation

---

# 20. Success Metrics

## First Six Months

Target:

- 1,000+ downloads
- 4.5+ rating
- 10% premium conversion
- 500+ active users

---

## Primary KPI

Percentage of users who successfully pass the Australian Citizenship Test after using the application.

---

# 21. Product Approval

This document defines the approved MVP scope for Pass Australian Citizenship Test.

FSD, SAD, Database Schema, UI/UX Specifications and Development Backlog must align with this document.