# AGENTS.md

## Pass Australian Citizenship Test - Project Reference

**Last Updated:** 2026-07-20

**Status:** MVP Planning Complete - Ready for Implementation

---

# Quick Overview

This is a **mobile study app** for the Australian Citizenship Test, built with **Flutter** (Dart).

**Key Principle:** Offline-first, no backend infrastructure for MVP.

---

# Project Status

## ✅ Completed
- Product Requirements Document (PRD)
- Functional Specification Document (FSD)
- Solution Architecture Document (SAD)
- Complete Database Schema
- Readiness Score Algorithm (invented)
- Weak Area Analysis Algorithm
- Implementation Details & Technical Specs

## 📋 Next Phase
- Flutter project scaffold
- Database layer (Drift/SQLite models)
- Core feature implementation
- UI/UX implementation

---

# Documentation Structure

All documentation in `/docs/` folder:

### [PRD.md](docs/PRD.md)
**What:** Business requirements and product vision
- Target audience: Australian Permanent Residents
- Unique selling points: clean UI, no ads, offline-first, detailed explanations
- Monetization: all features free; optional external Buy Me a Coffee support link
- Platform: Android + iOS (web deferred)

### [FSD.md](docs/FSD.md)
**What:** Detailed user behavior and feature specifications
- 5 main screens: Home, Practice, Mock Exams, Progress, Settings
- Feature breakdown: Practice Mode, Categories, Starred Questions, Mock Exams
- Feature access and support-link behaviour
- All UI text and workflows specified

### [SAD.md](docs/SAD.md)
**What:** Technical architecture and tech stack
- **Framework:** Flutter + Dart
- **State Management:** Riverpod
- **Database:** Drift + SQLite
- **Content:** JSON assets bundled with app
- **Support:** Optional external Buy Me a Coffee link; no feature gating
- **Architecture Pattern:** Clean Architecture with 4 layers

### [DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md)
**What:** Complete SQLite schema specification
- Local tables for questions, categories, options, explanations, references, attempts, stars, sessions, exams, analytics, history, and settings
- All indexes optimized for queries
- Data integrity constraints
- Views for analytics

### [ALGORITHMS.md](docs/ALGORITHMS.md)
**What:** Algorithmic specifications
- **Readiness Score:** 7-step algorithm (Base Accuracy 25%, Mock Exams 30%, Coverage/Mastery 20%, Difficulty 15%, Recency 5%, Trend 5%) → 0-100 score with interpretation bands
- **Weak Area Analysis:** Identifies low-performing categories
- **Performance Metrics:** Aggregation and tracking
- **Recommendations:** Rule-based suggestion engine

### [IMPLEMENTATION_DETAILS.md](docs/IMPLEMENTATION_DETAILS.md)
**What:** Technical implementation specifics
- Session persistence (app restart recovery, timer state)
- Timer edge cases (device time change, background behavior, auto-submit)
- Error handling (database corruption, JSON import failures, external-link errors)
- Accessibility (screen reader, text sizing, keyboard navigation)
- Performance targets (app launch < 3s, question load < 500ms, memory < 150MB)
- Testing requirements and deployment checklist

---

# Core Features

## Free Users
- Practice Mode (unlimited questions with immediate feedback)
- Category Practice (single, multiple, or all categories)
- Starred Questions (bookmark for revision)
- Progress Tracking (questions attempted, accuracy %, category performance)
- Untimed Mock Exams (practice exams without timer)

## All Users
- **Timed Mock Exams** (realistic exam simulation with timer)
- **Readiness Score** (0-100 confidence indicator)
- **Weak Area Analysis** (identify knowledge gaps)
- **Exam History** (track all historical exam results)
- **Advanced Analytics** (detailed performance breakdowns)

---

# Architecture Layers

```
Presentation Layer
    ↓
Application Layer
    ↓
Domain Layer
    ↓
Data Layer (Drift/SQLite)
```

**Folder Structure:**
```
lib/
├── core/              # Shared utilities, constants
├── features/          # Feature modules (practice, exams, progress, etc.)
│   ├── practice/
│   ├── categories/
│   ├── exams/
│   ├── progress/
│   ├── analytics/
│   └── settings/
└── shared/            # Shared widgets, services
```

---

# Question Bank

**Source:** "Our Common Bond" (official Australian citizenship book)

**Target:** 400-1000 questions (MVP minimum: 400)

**Question Structure:**
- Question text
- 4 answer options (exactly 1 correct)
- Difficulty level (easy, medium, hard)
- Category (loaded from database, not hardcoded)
- Explanation (why correct, why incorrect options wrong)
- Official reference (book, chapter, section, page)

---

# Configuration Driven

**Key Principle:** Exam rules are NOT hardcoded. Read from local configuration.

**Configurable:**
- Question count per exam (typically 20)
- Duration (typically 45 minutes)
- Pass mark (typically 75%)
- Australian values question count (5)
- Requirement to answer every Australian values question correctly

**Storage:** `exam_config.json` asset bundled with app

---

# Mock Exam Behavior

## Free Exam (Untimed)
- Same questions, same scoring
- No timer
- No readiness score
- No weak area analysis
- Can navigate forward/backward
- Can review unanswered questions

## Timed Exam
- Timer runs from start
- No pause button (maintains realism)
- Timer continues in background
- Auto-submit when time expires
- Get readiness score and weak area analysis
- Full exam history

## Exam Composition and Passing
- Each mock exam contains 20 randomly ordered questions
- Exactly 5 questions must be from Part 4: Australian values
- The remaining 15 questions are selected from Parts 1-3
- Passing requires both at least 15/20 overall and 5/5 Australian values
- Failing either condition results in a failed exam

---

# Timer Handling

**Key Points:**
- Based on elapsed real-world time (not app-level polling)
- Continues running while app backgrounded
- If app closed/backgrounded:
  - Remaining time recalculated on resume (elapsed = now - backgroundedAt)
  - If time expired: auto-submit
- If device time changed: timer locks to prevent cheating

---

# Session Persistence

**Practice Sessions:**
- Store: current question index, questions attempted, correct count, current question ID
- Restore: on app restart, show "Continue Learning?" prompt
- User can continue or start fresh

**Exam Sessions:**
- Store: all above + timer state + selected questions
- Restore: recalculate remaining time from background timestamp

---

# Readiness Score

**Algorithm Overview:**
1. Base Accuracy (from practice attempts)
2. Mock Exam Performance (average of completed exams)
3. Category Coverage (% of categories practiced)
4. Category Mastery (% of categories at 80%+ accuracy)
5. Difficulty Distribution (performance on easy/medium/hard)
6. Recency Bonus (recent practice within 1-7 days)
7. Trend Score (improvement across mock exams)

All weighted inputs are normalized to 0-100. Australian values then applies a
mandatory cap:
- Recent values practice below 5/5: maximum readiness 69
- 5/5 recent values practice without a qualifying latest mock: maximum 79
- One qualifying latest mock: maximum 89
- Two consecutive qualifying mocks: full 0-100 range

A qualifying mock passes at least 75% overall and 5/5 Australian values.

**Output:** 0-100 with bands:
- 90-100: Ready For Test
- 80-89: Very Well Prepared
- 70-79: Well Prepared
- 60-69: Moderately Prepared
- 50-59: Making Progress
- 40-49: Early Stage
- 0-39: Build Foundation

**Eligibility gate:** Hide the readiness score and show `Not enough data` until
the user has answered at least 20 practice questions in every active category.
A mock exam is still recommended for a more accurate score after eligibility is
reached.

---

# Key Decisions

✅ **Offline-First:** All data stored locally, no backend required for MVP
✅ **No Authentication:** No user accounts for MVP (future feature)
✅ **No Ads:** Clean, distraction-free experience differentiates from competitors
✅ **Configuration-Driven:** Exam rules changeable without code update (future)
✅ **Clean Architecture:** Maintainable, testable codebase for long-term growth
✅ **Free Feature Access:** No subscriptions, purchases, or entitlement gating

---

# Performance Targets

- App launch: < 3 seconds
- Question load: < 500ms
- Database queries: < 100ms
- Memory usage: < 150MB average
- Battery: < 15% drain per hour of active use

---

# Accessibility

- Screen reader support (all elements labeled)
- Text size support (100-200%)
- Color contrast (WCAG AA: 4.5:1 minimum)
- Keyboard navigation (Tab/arrow keys)
- No animation required to understand content

---

# Error Handling

**Corrupted Database:**
- Delete and recreate
- Re-import JSON assets
- Show user: "Data refreshed. Restart app."

**Missing JSON Assets:**
- Block practice/exam features
- Allow settings/about screens
- Show: "Content not available. Reinstall app."

**Support Link Failed:**
- Log the URL-launch error and allow retry
- Keep all study features available

**Out of Disk Space:**
- Warn user if < 50MB available
- Block content refresh if < 10MB available

---

# Testing Requirements

- 80% unit test coverage
- Integration tests for: practice flow, timed exam with timer, session persistence
- Manual tests for: rotation, timer + backgrounding, accessibility, corrupted DB recovery
- Real device testing before release

---

# Deployment Checklist

- [ ] All tests passing
- [ ] No critical bugs
- [ ] Performance targets met
- [ ] Accessibility audit passed
- [ ] Content reviewed for accuracy
- [ ] Privacy policy finalized
- [ ] Store listings ready (screenshots, descriptions)
- [ ] Build tested on real devices

---

# Versioning

**Format:** X.Y.Z (Semantic Versioning)

- 1.0.0 = MVP Release
- 1.1.0 = New features (e.g., improved analytics)
- 1.0.1 = Bug fixes
- 2.0.0 = Major changes (e.g., backend introduced)

---

# Next Steps for Implementation

1. **Project Scaffold** - Create Flutter project with folder structure and dependencies
2. **Database Layer** - Implement Drift models from DATABASE_SCHEMA.md
3. **Core Engines** - Readiness score, weak area analysis calculations
4. **Feature Implementation** - Practice, exams, progress tracking
5. **UI/Screens** - Implement FSD screens and workflows
6. **Testing** - Unit, integration, manual tests
7. **Content** - Create questions.json with 400+ questions
8. **Store Submission** - Prepare for Google Play and App Store release

---

# Useful References for Agents

When working on this project:

1. **Check PRD/FSD first** - For what the feature should do
2. **Check SAD** - For how to implement it technically
3. **Check DATABASE_SCHEMA** - For data storage patterns
4. **Check ALGORITHMS** - For calculation logic
5. **Check IMPLEMENTATION_DETAILS** - For edge cases and error handling

---

**Questions?** Check the relevant document in `/docs/` folder or refer back to this file.
