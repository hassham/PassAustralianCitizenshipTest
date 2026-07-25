# BACKLOG.md

## Pass Australian Citizenship Test - Implementation Backlog

**Last Updated:** 2026-07-24

**Priority Levels:** P0 (Critical/Blocker) | P1 (High/MVP Required) | P2 (Medium/Nice to Have) | P3 (Low/Future)

**Effort Estimates:** XS (< 2 hours) | S (2-4 hours) | M (4-8 hours) | L (8-16 hours) | XL (16+ hours)

---

## Tracker Dashboard

**Tracker updated:** 2026-07-24

| Status | Meaning | Tasks | Share |
|---|---|---:|---:|
| COMPLETE | Every acceptance item in the task is implemented and verified | 9 | 15% |
| PARTIAL | Useful scope is implemented, but acceptance items remain | 40 | 68% |
| IN PROGRESS | Actively being implemented | 0 | 0% |
| BLOCKED | Cannot proceed until the recorded blocker is resolved | 0 | 0% |
| NOT STARTED | No meaningful implementation yet | 10 | 17% |
| **Total** |  | **59** | **100%** |

### Phase roll-up

| Phase | Complete | Partial | In progress | Blocked | Not started |
|---|---:|---:|---:|---:|---:|
| 1. Setup | 1 | 2 | 0 | 0 | 1 |
| 2. Database | 0 | 6 | 0 | 0 | 2 |
| 3. Domain logic | 5 | 2 | 0 | 0 | 0 |
| 4. State management | 1 | 2 | 0 | 0 | 0 |
| 5. Feature engines | 0 | 5 | 0 | 0 | 1 |
| 6. Screens | 2 | 7 | 0 | 0 | 1 |
| 7. Shared UI | 0 | 3 | 0 | 0 | 0 |
| 8. Testing | 0 | 4 | 0 | 0 | 0 |
| 9. Content | 0 | 3 | 0 | 0 | 0 |
| 10. Optimization | 0 | 4 | 0 | 0 | 0 |
| 11. Platforms | 0 | 2 | 0 | 0 | 1 |
| 12. Release | 0 | 0 | 0 | 0 | 4 |

### Tracker conventions

- Every task has a status, owner, target, and last-updated date.
- `COMPLETE` means the entire original task scope is done, not merely the current vertical-slice subset.
- `PARTIAL` records both implemented evidence and the most important remaining work.
- `Owner: Unassigned` means the task is available for assignment.
- `Target: Backlog` means the task has no committed delivery date.
- File paths under `Evidence` are the implementation proof for the recorded status.
- Status changes should update this dashboard, the task metadata, and the change log at the bottom.

### Next-up queue

| Order | Task | Outcome | Exit check |
|---:|---|---|---|
| 1 | 5.5 Premium Manager | Add store-backed entitlement and feature gating | Premium access survives purchase and restore |
| 2 | 11.3 In-App Purchases | Integrate Google Play and Apple purchase lifecycles | Sandbox purchase, restore, retry, and cancellation pass |
| 3 | 6.9 Premium Screen | Add pricing, purchase, restore, and confirmation UI | Purchase entry points match the FSD |
| 4 | 8.4 Manual Testing | Validate timer backgrounding, expiry, clock lock, and analytics on devices | Checklist results and defects are recorded |
| 5 | 9.1 Question Dataset | Complete owner review when the app is production-ready | Content review gates pass |
| 6 | 12.4 Beta Testing | Run signed beta builds after purchases and content approval | Release-candidate defects are closed |

## Implementation Progress

**Milestone 1 - Offline Practice Vertical Slice: Complete (2026-07-20)**

Completed in this milestone:
- Flutter scaffold for Android, iOS, web, Windows, macOS, and Linux
- Riverpod application state and accessible Material 3 theme
- Drift/SQLite database with categories, questions, attempts, and resumable practice sessions
- Idempotent JSON content import with concurrent-startup protection
- 12 development-only sample questions across three categories
- Category and all-category practice flows
- Immediate answer feedback, explanations, session results, and progress summary
- Automatic unfinished-session persistence and "Continue Learning?" restoration
- Repository and widget tests; static analysis passes with no findings
- Git repository initialized

Deferred to later milestones:
- Production-reviewed 500+ question bank
- Mock exams, timer, starred questions, premium purchases, and analytics engines
- Remaining database tables from `docs/DATABASE_SCHEMA.md`
- Android APK verification (Android SDK is not installed on the current machine)

**Milestone 2 - Android Baseline, Starred Questions & Navigation: Implemented (2026-07-21)**

Completed in this milestone:
- Android SDK/emulator toolchain verified with no `flutter doctor` findings
- Debug APK built and installed on `emulator-5554`
- Versioned Drift migration adds persistent starred questions
- Star/unstar control added to the practice screen
- Starred-question list and focused practice action added
- Five-section shell added: Home, Practice, Exams, Progress, and Settings
- Practice hub and basic progress summary added; deferred sections show explicit placeholders
- Star persistence and navigation tests added; all 5 automated tests pass

Still required before this milestone is considered fully complete:
- Remaining resilience/accessibility scenarios and formal defect recording
- Real Android device testing and release-signing configuration

**Milestone 3 - Configurable Category Practice: Implemented (2026-07-22)**

Completed in this milestone:
- User-confirmed emulator walkthrough for starring and five-section navigation
- Single, multiple, and all-category selection in the Practice hub
- Choice of 5, 10, 20, or all available questions
- Safe clamping when selected categories contain fewer questions than requested
- Randomized filtering in the repository before session persistence
- Multi-category repository and deterministic Practice-hub widget coverage
- Static analysis passes and all 7 automated tests pass

**Milestone 4 - Free Untimed Mock Exams: Implemented (2026-07-22)**

Completed in this milestone:
- Versioned schema-v3 migration for exam configurations, attempts, and answers
- Exam rules loaded from bundled `exam_config.json`
- Random question selection safely clamped to available starter content
- Untimed answer selection without immediate feedback
- Forward/back navigation and answered/unanswered question navigator
- Persisted answer and current-position recovery after restart
- Submission confirmation with unanswered count
- Configuration-driven score and pass/fail calculation
- Results summary plus complete answer and explanation review
- Exams tab start/resume experience and explicit Premium timed-exam placeholder
- Repository coverage for configuration, persistence, ordering, scoring, and completion
- Static analysis clean, all 9 automated tests passing, and Android debug APK built

**Milestone 5 - Production Question-Bank Pipeline: Implemented (2026-07-23)**

Completed in this milestone:
- Formal Draft 2020-12 question-bank schema added under `docs/`
- 120-question production-format bank imported while content remains `ready_for_review`
- Structural and semantic validation for IDs, categories, sources, options, correct answers, and page ranges
- Normalized option, source-edition, reference, metadata, removal, and stable answer-selection storage
- Version-aware transactional updates replace destructive question-bank refreshes
- Removed questions are retained as tombstones for starred items and historical attempts
- Practice and exam review show option-level explanations and official source pages
- Starred-question removal notice and acknowledgement flow added

Still required before production release:
- Owner editorial approval of every question
- Content-volume target decision and any additional approved questions
- Final licensing/attribution review
- Final manual emulator walkthrough of the production-format feedback and removal messages

**Milestone 6 - Navigation, Recovery & Home Dashboard: Implemented (2026-07-23)**

Completed in this milestone:
- Named `go_router` routes for all five sections and active practice/exam flows
- Stateful indexed navigation preserves each section while switching tabs
- Explicit saved-progress confirmation for Android/system back from active sessions
- Typed content, storage, and unexpected failures with actionable user messages
- Retryable question-bank import and safe bundled-content refresh that preserves user data
- Confirmed last-resort corrupted-database reset with a restart instruction
- Home dashboard shows accuracy, attempts, question count, starred count, quick actions, and active practice/exam resume cards
- Loading skeletons, pull-to-refresh, polished failure states, and focused coverage
- Static analysis clean, all 14 automated tests passing, and Android debug APK built

**Milestone 7 - Release Information, Free Analytics & History: Implemented (2026-07-23)**

Completed in this milestone:
- Category accuracy, question coverage, seven-day activity, strong/weak summaries, and useful Progress empty states
- App and question-bank versions, source attribution, disclaimer, privacy/support links, content refresh, progress reset, and starred reset controls
- Difficulty-filtered practice, direct removal from Starred, large-text-responsive layouts, and archived-session safeguards
- Completed-exam history, result details, answer review, and removed-question notices for historical attempts
- Ordered keyboard focus, screen-reader semantics, high-contrast theme support, and automated 200% text-scale coverage
- Structured logs, low-storage detection, import/startup/database/migration timings, and resident-memory diagnostics
- Static analysis clean and all 18 automated tests passing

Still required before release:
- Manual TalkBack/VoiceOver and keyboard walkthrough on target devices
- Formal measured contrast audit and DevTools profiling under the final reviewed question bank
- Owner editorial approval and final real-device release checklist

**Milestone 8 - Premium Exams & Analytics Foundation: Implemented (2026-07-24)**

Completed in this milestone:
- Schema-v6 timed-exam persistence for remaining time, lifecycle timestamps, clock lock, time taken, and analytics snapshots
- Real-world timer with background/restart recalculation, warning bands, automatic expiry submission, and backwards-clock protection
- Timed premium-preview entry, always-visible timer, saved recovery, timeout results, and timed history duration
- Seven-step readiness score with documented bands, minimum-data handling, mock confidence penalty, and trends
- Ranked weak-area analysis using sample thresholds, severity gaps, and repeated medium/hard misses
- Six-rule prioritized recommendations and exam-score trend summaries
- Premium analytics on Home, Progress, and timed-exam results, ready for entitlement gating
- Static analysis clean and all 30 automated tests passing

Explicitly deferred:
- Store purchases, restore purchases, entitlement persistence, pricing UI, and production feature gating
- Owner editorial question review until the app reaches production readiness

---

# Phase 1: Project Setup & Infrastructure

## Task 1.1: Create Flutter Project Scaffold
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-20  
**Evidence:** `lib/`, platform folders, `test/`, `pubspec.yaml`  
**Remaining:** None for the scaffold task.
**Priority:** P0 | **Effort:** M

Create base Flutter project with:
- Initialize Flutter project: `flutter create pass_citizenship_test`
- Set up folder structure (Clean Architecture)
- Create core/ folder for utilities and constants
- Create features/ subfolder structure (practice, categories, exams, progress, analytics, premium, settings)
- Create shared/ folder for widgets and services
- Create lib/main.dart entry point
- Create pubspec.yaml with all dependencies (see Task 1.2)

**Dependencies:** None
**Related Docs:** SAD.md (Architecture section)

---

## Task 1.2: Configure pubspec.yaml with Dependencies
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Riverpod, Drift, routing, path utilities, code generation, and linting are configured in `pubspec.yaml`.  
**Remaining:** Add localization, purchase, mocking, and integration-test dependencies only when their features begin; review unused packages.
**Priority:** P0 | **Effort:** S

Add all required dependencies to pubspec.yaml:
- **State Management:** riverpod, flutter_riverpod, riverpod_generator, build_runner
- **Database:** drift, drift_flutter, sqlite3_flutter_libs
- **Code Generation:** build_runner, drift_generator
- **UI:** flutter_localizations, intl
- **In-App Purchases:** in_app_purchase
- **Testing:** test, mocktail, integration_test
- **Linting:** flutter_lints

Run: `flutter pub get`

**Dependencies:** Task 1.1
**Related Docs:** SAD.md (Tech Stack section)

---

## Task 1.3: Set Up Build Configurations
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Backlog | **Updated:** 2026-07-20
**Priority:** P0 | **Effort:** S

Configure build settings:
- android/app/build.gradle (min SDK 21, target SDK 34)
- ios/Podfile (deployment target iOS 12.0+)
- .env files for different build flavors (dev, staging, production)
- Configure code signing for iOS and Android

**Dependencies:** Task 1.1
**Related Docs:** SAD.md

---

## Task 1.4: Create Project Constants & Utils
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Backlog | **Updated:** 2026-07-20  
**Evidence:** Application name and starter-content warning exist in `lib/core/constants/app_constants.dart`.  
**Remaining:** Exam defaults, logging, date/time helpers, and validators.
**Priority:** P1 | **Effort:** S

Create core utilities:
- lib/core/constants/app_constants.dart (app name, version, default values)
- lib/core/constants/exam_defaults.dart (20 questions, 45 min, 75% pass mark)
- lib/core/utils/logger.dart (logging utility with levels)
- lib/core/utils/date_time_utils.dart (timestamp conversions, formatting)
- lib/core/utils/validators.dart (input validation functions)

**Dependencies:** Task 1.1
**Related Docs:** IMPLEMENTATION_DETAILS.md (Logging section)

---

# Phase 2: Database & Data Layer

## Task 2.1: Create Drift Database Configuration
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Persistent SQLite connection, schema version, four registered tables, and generated Drift bindings in `lib/data/database/`.  
**Remaining:** Define migration strategy and production database recovery behavior.
**Priority:** P0 | **Effort:** M

Set up Drift SQLite:
- Create lib/data/database/app_database.dart
- Define database initialization
- Set up migration strategy
- Configure SQLite version and settings
- Create database connection singleton

**Dependencies:** Task 1.2
**Related Docs:** DATABASE_SCHEMA.md (Design Principles section)

---

## Task 2.2: Create Database Models - Content Tables
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Content milestone | **Updated:** 2026-07-20  
**Evidence:** Categories, questions, normalized options, source editions, page references, question metadata, and removal tombstones are persisted through the schema-v5 migration.
**Remaining:** Reconcile the broader 14-table documentation model and add migration performance measurements.
**Priority:** P0 | **Effort:** L

Create Drift models for content tables:
- lib/data/database/tables/categories_table.dart
- lib/data/database/tables/questions_table.dart
- lib/data/database/tables/question_options_table.dart
- lib/data/database/tables/question_explanations_table.dart
- lib/data/database/tables/question_references_table.dart
- lib/data/database/tables/exam_configurations_table.dart

Generate with: `flutter pub run build_runner build`

**Dependencies:** Task 2.1
**Related Docs:** DATABASE_SCHEMA.md (Core Tables section)

---

## Task 2.3: Create Database Models - User Progress Tables
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Question attempts and resumable practice sessions are implemented.  
**Remaining:** Starred questions, richer session fields, performance metrics, constraints, and indexes.
**Priority:** P0 | **Effort:** L

Create Drift models for progress tracking:
- lib/data/database/tables/user_question_attempts_table.dart
- lib/data/database/tables/user_starred_questions_table.dart
- lib/data/database/tables/user_practice_sessions_table.dart

**Dependencies:** Task 2.1
**Related Docs:** DATABASE_SCHEMA.md (User Progress Tables section)

---

## Task 2.4: Create Database Models - Exam Tables
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Architecture cleanup | **Updated:** 2026-07-24
**Evidence:** Schema v6 includes configuration, answers, stable selections, timed state, lifecycle timestamps, clock lock, time taken, score, and completion.
**Remaining:** Attempt numbering, richer foreign-key constraints/indexes, and production upgrade-path tests.
**Priority:** P0 | **Effort:** L

Create Drift models for exam data:
- lib/data/database/tables/exam_attempts_table.dart
- lib/data/database/tables/exam_attempt_answers_table.dart
- lib/data/database/tables/exam_history_table.dart

**Dependencies:** Task 2.1
**Related Docs:** DATABASE_SCHEMA.md (Mock Exam Tables section)

---

## Task 2.5: Create Database Models - Analytics & Premium Tables
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Premium milestone | **Updated:** 2026-07-20
**Priority:** P0 | **Effort:** M

Create Drift models for analytics and settings:
- lib/data/database/tables/user_performance_metrics_table.dart
- lib/data/database/tables/premium_entitlements_table.dart
- lib/data/database/tables/app_settings_table.dart
- lib/data/database/tables/user_preferences_table.dart
- lib/data/database/tables/content_versions_table.dart

**Dependencies:** Task 2.1
**Related Docs:** DATABASE_SCHEMA.md (Analytics & Premium sections)

---

## Task 2.6: Create Database Queries & DAOs
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** `PracticeRepository` provides category, question, attempt, progress, and session operations.  
**Remaining:** Split full-schema operations into feature DAOs and add exam, analytics, starred, premium, and settings queries.
**Priority:** P1 | **Effort:** L

Create data access objects:
- lib/data/database/daos/question_dao.dart (query questions, options, explanations)
- lib/data/database/daos/practice_session_dao.dart (CRUD for sessions)
- lib/data/database/daos/exam_dao.dart (CRUD for exams)
- lib/data/database/daos/progress_dao.dart (CRUD for attempts and metrics)
- lib/data/database/daos/starred_dao.dart (CRUD for starred questions)
- lib/data/database/daos/premium_dao.dart (CRUD for premium data)

**Dependencies:** Task 2.2, 2.3, 2.4, 2.5
**Related Docs:** DATABASE_SCHEMA.md (entire document)

---

## Task 2.7: Create Database Initialization & JSON Import
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Content milestone | **Updated:** 2026-07-20  
**Evidence:** Bundled JSON validates structurally and semantically, imports transactionally by bank version, updates records without deleting user history, and records removed-question tombstones.
**Remaining:** Corruption recovery UI, richer import diagnostics, and production-volume performance measurements.
**Priority:** P0 | **Effort:** L

Implement content loading:
- lib/data/database/database_init.dart (initialization logic)
- lib/data/repositories/question_repository.dart (load from JSON assets)
- Create assets/data/questions.json (initial empty structure)
- Create assets/data/categories.json
- Create assets/data/exam_config.json
- Implement JSON parsing and validation
- Implement batch insert for performance

**Dependencies:** Task 2.1, 2.6
**Related Docs:** IMPLEMENTATION_DETAILS.md (Content Management section)

---

## Task 2.8: Create Database Views & Analytics Queries
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Analytics milestone | **Updated:** 2026-07-20
**Priority:** P2 | **Effort:** M

Implement database views:
- Create v_user_statistics view
- Create v_active_questions view
- Create analytics query methods in DAOs
- Test query performance against targets

**Dependencies:** Task 2.6
**Related Docs:** DATABASE_SCHEMA.md (Migrations & Integrity Views section)

---

# Phase 3: Core Domain Logic & Engines

## Task 3.1: Implement Readiness Score Calculator
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Pure seven-step calculator implements minimum data, mock confidence, coverage/mastery, difficulty, recency, trends, bounds, bands, and the documented example tests.
**Remaining:** None.
**Priority:** P1 | **Effort:** L

Create readiness score calculation engine:
- lib/domain/entities/readiness_model.dart (data model)
- lib/domain/usecases/calculate_readiness_score_usecase.dart
- Implement 7-step algorithm from ALGORITHMS.md
- Implement readiness band classification
- Handle minimum data requirements
- Add unit tests (80% coverage)

**Dependencies:** Task 2.6
**Related Docs:** ALGORITHMS.md (Readiness Score Algorithm section)

---

## Task 3.2: Implement Weak Area Analysis Engine
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Analytics ranks up to three weak categories by severity using the documented sample and accuracy thresholds and identifies repeated medium/hard misses.
**Remaining:** None.
**Priority:** P1 | **Effort:** M

Create weak area analysis:
- lib/domain/entities/weak_area_model.dart
- lib/domain/usecases/analyze_weak_areas_usecase.dart
- Implement algorithm from ALGORITHMS.md
- Identify weak categories with severity ranking
- Generate top 3 recommendations
- Add unit tests (80% coverage)

**Dependencies:** Task 2.6
**Related Docs:** ALGORITHMS.md (Weak Area Analysis section)

---

## Task 3.3: Implement Performance Metrics Calculator
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Final-content profiling | **Updated:** 2026-07-24
**Evidence:** Overall, category, difficulty, recency, coverage, mock-exam, and trend metrics are calculated locally and performance-instrumented.
**Remaining:** Decide whether persisted aggregate caching is justified after final-bank profiling and add regression thresholds.
**Priority:** P1 | **Effort:** M

Create performance metrics aggregation:
- lib/domain/usecases/calculate_performance_metrics_usecase.dart
- Overall statistics calculation
- Per-category statistics
- Mock exam statistics
- Update caching strategy
- Add unit tests

**Dependencies:** Task 2.6
**Related Docs:** ALGORITHMS.md (Performance Metrics Aggregation section)

---

## Task 3.4: Implement Recommendation Engine
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Pure prioritized engine implements all six documented rules for exams, readiness, weak areas, coverage, and inactivity with focused tests.
**Remaining:** None.
**Priority:** P2 | **Effort:** M

Create recommendation logic:
- lib/domain/entities/recommendation_model.dart
- lib/domain/usecases/generate_recommendations_usecase.dart
- Implement 6 recommendation rules from ALGORITHMS.md
- Prioritize recommendations
- Add unit tests

**Dependencies:** Task 3.1, 3.2, 3.3
**Related Docs:** ALGORITHMS.md (Recommendation Engine section)

---

## Task 3.5: Implement Mock Exam Scoring Engine
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Architecture cleanup | **Updated:** 2026-07-22
**Evidence:** Configuration-driven scoring calculates percentage, pass/fail, correct, incorrect, and unanswered counts and persists the result.
**Remaining:** Extract the calculation into a pure domain service and add mandatory-rule scoring when those rules are defined.
**Priority:** P1 | **Effort:** S

Create exam scoring:
- lib/domain/usecases/score_exam_usecase.dart
- Calculate overall score
- Calculate pass/fail
- Generate per-category breakdown
- Add unit tests

**Dependencies:** Task 2.6
**Related Docs:** ALGORITHMS.md (Mock Exam Scoring section)

---

## Task 3.6: Implement Timer Engine (Timed Exams)
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Pure real-time engine plus lifecycle integration handles persistence, background/resume, restart, warnings, expiry, auto-submit, and backwards-clock locking.
**Remaining:** None.
**Priority:** P1 | **Effort:** M

Create timer handling:
- lib/domain/services/timer_service.dart
- Calculate remaining time based on elapsed real-world time
- Handle background/resume transitions
- Detect device time changes
- Handle timer expiry
- Add unit tests for edge cases

**Dependencies:** Task 2.4
**Related Docs:** IMPLEMENTATION_DETAILS.md (Timer Edge Cases section)

---

## Task 3.7: Implement Session Persistence Service
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Practice, untimed, and timed exams persist question order, answers, position, lifecycle/timer state, scoring, completion, restoration, and expiry submission.
**Remaining:** None.
**Priority:** P1 | **Effort:** M

Create session management:
- lib/domain/services/session_service.dart
- Save practice session state
- Restore practice session on app restart
- Handle exam session persistence
- Prompt for session continuation
- Add unit tests

**Dependencies:** Task 2.3, 2.4, 3.6
**Related Docs:** IMPLEMENTATION_DETAILS.md (Session Persistence section)

---

# Phase 4: State Management & Application Layer

## Task 4.1: Create Riverpod Providers - Database Layer
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Database and practice-repository providers manage creation and disposal.  
**Remaining:** Providers for the remaining feature repositories/DAOs and test overrides for each boundary.
**Priority:** P1 | **Effort:** M

Set up state management:
- lib/application/providers/database_provider.dart (database singleton)
- lib/application/providers/question_provider.dart (question queries)
- lib/application/providers/category_provider.dart (categories)
- lib/application/providers/exam_config_provider.dart (exam config)

**Dependencies:** Task 2.6, 3.6
**Related Docs:** SAD.md (State Management section)

---

## Task 4.2: Create Riverpod Providers - Business Logic
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Analytics milestone | **Updated:** 2026-07-20  
**Evidence:** Category and progress summary providers are implemented.  
**Remaining:** Store-backed premium entitlement provider when purchases begin.
**Priority:** P1 | **Effort:** M

Create business logic providers:
- lib/application/providers/readiness_score_provider.dart
- lib/application/providers/weak_areas_provider.dart
- lib/application/providers/performance_metrics_provider.dart
- lib/application/providers/recommendations_provider.dart

**Dependencies:** Task 3.1, 3.2, 3.3, 3.4
**Related Docs:** SAD.md (State Management section)

---

## Task 4.3: Create Riverpod Providers - Session Management
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Controllers manage loading, answers, navigation, persistence, restoration, real-time countdown, app lifecycle, clock lock, and timeout submission.
**Remaining:** None.
**Priority:** P1 | **Effort:** M

Create session providers:
- lib/application/providers/current_session_provider.dart
- lib/application/providers/current_exam_provider.dart
- lib/application/providers/timer_provider.dart (for timed exams)
- lib/application/providers/user_progress_provider.dart

**Dependencies:** Task 3.6, 3.7, 4.1
**Related Docs:** SAD.md (State Management section)

---

# Phase 5: Feature Implementation - Core Engines

## Task 5.1: Implement Practice Session Engine
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Randomized category/all-category sessions, answer evaluation, results, persistence, and resume are working.  
**Remaining:** Richer exit handling, retry behavior, and full FSD edge-case coverage.
**Priority:** P1 | **Effort:** L

Create practice flow:
- lib/features/practice/domain/usecases/start_practice_usecase.dart
- lib/features/practice/domain/usecases/submit_answer_usecase.dart
- lib/features/practice/domain/usecases/navigate_question_usecase.dart
- lib/features/practice/domain/usecases/end_practice_usecase.dart
- Handle question randomization
- Handle answer validation
- Handle session persistence
- Add integration tests

**Dependencies:** Task 3.7, 4.3
**Related Docs:** FSD.md (Practice Mode section)

---

## Task 5.2: Implement Mock Exam Engine
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Premium exam milestone | **Updated:** 2026-07-22
**Evidence:** Free untimed exams support configuration-based randomized creation, answer persistence, navigation, resume, submission, scoring, and review.
**Remaining:** Store entitlement gating, further domain-use-case extraction, and device-level integration coverage.
**Priority:** P1 | **Effort:** L

Create exam flow:
- lib/features/exams/domain/usecases/create_exam_usecase.dart
- lib/features/exams/domain/usecases/start_exam_usecase.dart
- lib/features/exams/domain/usecases/submit_exam_answer_usecase.dart
- lib/features/exams/domain/usecases/submit_exam_usecase.dart
- Random question selection per config
- Timed vs untimed exam support
- Auto-submit on timer expiry
- Add integration tests

**Dependencies:** Task 3.5, 3.6, 5.1
**Related Docs:** FSD.md (Mock Exams section)

---

## Task 5.3: Implement Category Filtering
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Architecture cleanup | **Updated:** 2026-07-22
**Evidence:** Single, multiple, and all-category filtering plus 5/10/20/all session lengths are database-driven and covered by repository tests.
**Remaining:** Extract the filtering behavior into the domain use cases specified by the original architecture.
**Priority:** P1 | **Effort:** M

Create category selection:
- lib/features/categories/domain/usecases/get_categories_usecase.dart
- lib/features/categories/domain/usecases/filter_questions_by_category_usecase.dart
- Single category selection
- Multiple category selection
- All categories selection
- Add unit tests

**Dependencies:** Task 2.6
**Related Docs:** FSD.md (Category Practice section)

---

## Task 5.4: Implement Starred Questions System
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-21
**Evidence:** Persistent star/unstar operations, starred retrieval, focused starred practice, schema migration, and repository tests are implemented.
**Remaining:** Archive handling and separation into dedicated domain use cases.
**Priority:** P1 | **Effort:** M

Create starred questions functionality:
- lib/features/starred/domain/usecases/star_question_usecase.dart
- lib/features/starred/domain/usecases/unstar_question_usecase.dart
- lib/features/starred/domain/usecases/get_starred_questions_usecase.dart
- lib/features/starred/domain/usecases/practice_starred_usecase.dart
- Archive handling for starred questions
- Add unit tests

**Dependencies:** Task 2.3, 5.1
**Related Docs:** FSD.md (Starred Questions section)

---

## Task 5.5: Implement Premium Features Manager
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Premium milestone | **Updated:** 2026-07-20
**Priority:** P1 | **Effort:** M

Create premium features:
- lib/features/premium/domain/usecases/check_premium_status_usecase.dart
- lib/features/premium/domain/usecases/process_purchase_usecase.dart
- lib/features/premium/domain/usecases/restore_purchases_usecase.dart
- lib/features/premium/domain/usecases/grant_timed_exam_access_usecase.dart
- Feature gating (readiness score, weak areas, exam history)
- Add unit tests

**Dependencies:** Task 2.5
**Related Docs:** PRD.md (Premium Model section)

---

## Task 5.6: Implement Error Handling Service
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Continuous | **Updated:** 2026-07-23
**Evidence:** Typed content/storage/unexpected failures, retry UI, safe content refresh, confirmed corrupted-database reset, and focused failure-mapping tests are implemented.
**Remaining:** Structured logging, low-disk detection, and purchase-specific error handling when purchases begin.
**Priority:** P1 | **Effort:** M

Create error handling:
- lib/core/errors/exceptions.dart (custom exceptions)
- lib/core/errors/error_handler.dart (centralized error handling)
- lib/data/services/database_recovery_service.dart (DB corruption recovery)
- lib/data/services/json_import_error_service.dart (JSON import error handling)
- lib/data/services/purchase_error_service.dart (purchase error handling)
- Logging integration
- Add unit tests

**Dependencies:** Task 1.4, 2.7
**Related Docs:** IMPLEMENTATION_DETAILS.md (Error Handling Strategy section)

---

# Phase 6: UI/Presentation Layer - Screens

## Task 6.1: Create App Shell & Navigation
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-23
**Evidence:** Named routes, stateful five-section shell, full-screen session routes, not-found recovery, and saved-progress back confirmation are implemented and tested.
**Remaining:** None for the current free-app navigation scope.
**Priority:** P1 | **Effort:** M

Create app structure:
- lib/presentation/app.dart (main app widget)
- lib/presentation/navigation/app_router.dart (routing setup)
- lib/presentation/screens/shell/bottom_navigation_shell.dart
- Set up 5 bottom nav tabs: Home, Practice, Exams, Progress, Settings
- Handle navigation and state persistence

**Dependencies:** Task 4.1
**Related Docs:** FSD.md (Application Navigation section)

---

## Task 6.2: Implement Home Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Premium analytics milestone | **Updated:** 2026-07-23
**Evidence:** Home shows accuracy, attempts, total and starred counts, practice/exam quick actions, active-session resume cards, loading skeletons, pull-to-refresh, and actionable recovery states.
**Remaining:** Replace the premium preview with store entitlement state and complete final visual/device QA.
**Priority:** P1 | **Effort:** M

Create home screen:
- lib/presentation/screens/home/home_screen.dart
- lib/presentation/providers/home_provider.dart
- Display welcome banner
- Display quick statistics (attempts, accuracy, starred count)
- Display continue learning section (if session active)
- Display quick action buttons
- Display premium banner (non-premium users)
- Add unit and widget tests

**Dependencies:** Task 4.2, 6.1
**Related Docs:** FSD.md (Home Screen section)

---

## Task 6.3: Implement Practice Mode Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Question progress, options, answer locking, correct/incorrect styling, explanation, next action, and results are implemented.  
**Remaining:** Exit confirmation, configurable flows, full responsive QA, and remaining accessibility verification.
**Priority:** P1 | **Effort:** L

Create practice flow:
- lib/presentation/screens/practice/practice_mode_screen.dart
- lib/presentation/screens/practice/question_screen.dart
- lib/presentation/screens/practice/answer_feedback_screen.dart
- lib/presentation/providers/practice_provider.dart
- Display question with 4 options
- Show category, difficulty, star icon
- Implement option selection flow
- Show correct/incorrect feedback with colors
- Display explanation and reference
- Navigation buttons (Previous, Next)
- Add widget tests

**Dependencies:** Task 5.1, 6.1
**Related Docs:** FSD.md (Practice Mode section)

---

## Task 6.4: Implement Category Selection Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Architecture cleanup | **Updated:** 2026-07-22
**Evidence:** The Practice hub provides all-category, single-category, multi-category, question-count, validation, availability feedback, and start-session controls with widget coverage.
**Remaining:** Extract the selection workflow to its own route/provider if named routing warrants it, then complete visual and accessibility QA.
**Priority:** P1 | **Effort:** S

Create category picker:
- lib/presentation/screens/categories/categories_screen.dart
- lib/presentation/providers/categories_provider.dart
- Display all categories
- Single category selection
- Multiple category selection (checkboxes)
- "All Categories" option
- Start practice button
- Add widget tests

**Dependencies:** Task 5.3, 6.1
**Related Docs:** FSD.md (Category Practice section)

---

## Task 6.5: Implement Starred Questions Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-21
**Evidence:** Starred list, empty state, saved count, and focused practice action are implemented and reachable from the Practice hub.
**Remaining:** Category/difficulty filters, direct removal from the list, archive messaging, and broader widget coverage.
**Priority:** P1 | **Effort:** M

Create starred view:
- lib/presentation/screens/starred/starred_questions_screen.dart
- lib/presentation/providers/starred_provider.dart
- Display starred questions list
- Filters: category, difficulty
- Practice starred questions action
- Remove from starred action
- Archive handling message
- Add widget tests

**Dependencies:** Task 5.4, 6.1
**Related Docs:** FSD.md (Starred Questions section)

---

## Task 6.6: Implement Mock Exams Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Premium exam milestone | **Updated:** 2026-07-22
**Evidence:** Exams home, free exam question flow, unanswered navigator, confirmation, results, answer review, and resume card are implemented.
**Remaining:** Store entitlement gating plus final device-level timer and accessibility validation.
**Priority:** P1 | **Effort:** L

Create exam flows:
- lib/presentation/screens/exams/exams_screen.dart
- lib/presentation/screens/exams/exam_question_screen.dart (for timed)
- lib/presentation/screens/exams/exam_results_screen.dart
- lib/presentation/screens/exams/exam_review_screen.dart
- lib/presentation/providers/exam_provider.dart
- Start free untimed exam
- Start premium timed exam (with timer display)
- Answer submission flow
- Results display (score, pass/fail)
- Review with correct answers
- Add widget and integration tests

**Dependencies:** Task 5.2, 5.5, 6.1
**Related Docs:** FSD.md (Mock Exams & Premium Timed Exams sections)

---

## Task 6.7: Implement Progress Screen
**Status:** COMPLETE | **Owner:** Unassigned | **Target:** Delivered | **Updated:** 2026-07-24
**Evidence:** Progress displays overall/category accuracy, coverage, activity, readiness, weak areas, prioritized recommendations, trends, responsive states, and large-text regression coverage.
**Remaining:** None for the screen; purchase gating belongs to the premium manager.
**Priority:** P1 | **Effort:** M

Create progress tracking:
- lib/presentation/screens/progress/progress_screen.dart
- lib/presentation/providers/progress_provider.dart
- Display overall statistics (attempts, accuracy)
- Display category performance chart/list
- Display readiness score (premium only)
- Display weak areas (premium only)
- Display recommendations
- Add widget tests

**Dependencies:** Task 3.1, 3.2, 3.3, 4.2, 6.1
**Related Docs:** FSD.md, ALGORITHMS.md

---

## Task 6.8: Implement Exam History Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Premium analytics milestone | **Updated:** 2026-07-23
**Evidence:** `lib/features/exams/presentation/exam_history_screen.dart`, `exam_history_detail_screen.dart`, and repository providers list submitted exams and review stable historical answers, including removed-question notices.
**Remaining:** Store entitlement gating and dedicated history widget tests.
**Priority:** P2 | **Effort:** M

Create history view (premium):
- lib/presentation/screens/progress/exam_history_screen.dart
- lib/presentation/providers/exam_history_provider.dart
- Display all completed exams
- Show date, score, pass/fail status
- Show trend/improvement
- Ability to review past exams
- Add widget tests

**Dependencies:** Task 5.5, 6.7
**Related Docs:** PRD.md (Premium Features section)

---

## Task 6.9: Implement Premium Screen
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Premium milestone | **Updated:** 2026-07-20
**Priority:** P1 | **Effort:** M

Create premium upsell:
- lib/presentation/screens/premium/premium_screen.dart
- lib/presentation/providers/premium_provider.dart
- Display premium features list
- Display pricing
- Purchase button
- Restore purchases button
- Handle purchase flow
- Show purchase confirmation
- Add widget tests

**Dependencies:** Task 5.5, 6.1
**Related Docs:** PRD.md (Monetization section)

---

## Task 6.10: Implement Settings Screen
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Release settings milestone | **Updated:** 2026-07-23
**Evidence:** `lib/features/settings/` displays app/content/source versions, attribution, disclaimer, privacy/support/licence links, storage/performance diagnostics, refresh, reset progress, and clear-starred controls.
**Remaining:** Theme preference, notification settings if retained, explicit terms-of-service decision, and dedicated Settings widget tests.
**Priority:** P1 | **Effort:** M

Create settings:
- lib/presentation/screens/settings/settings_screen.dart
- lib/presentation/providers/settings_provider.dart
- Display app version
- Text size preference (100-200%)
- Theme preference (light/dark)
- Notification settings
- About section
- Privacy policy link
- Terms of service link
- Add widget tests

**Dependencies:** Task 4.1, 6.1
**Related Docs:** IMPLEMENTATION_DETAILS.md (Accessibility section)

---

# Phase 7: UI Components & Shared Widgets

## Task 7.1: Create Common Widgets
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Reusable themed cards, buttons, progress treatments, and result presentation patterns exist in the current screens.  
**Remaining:** Extract formal shared widgets, document their APIs, and add component-level tests.
**Priority:** P2 | **Effort:** M

Build reusable components:
- lib/presentation/widgets/question_card.dart
- lib/presentation/widgets/option_button.dart
- lib/presentation/widgets/score_display.dart
- lib/presentation/widgets/progress_bar.dart
- lib/presentation/widgets/category_chip.dart
- lib/presentation/widgets/difficulty_badge.dart
- lib/presentation/widgets/star_icon_button.dart
- lib/presentation/widgets/empty_state.dart
- lib/presentation/widgets/loading_indicator.dart

**Dependencies:** Task 6.1
**Related Docs:** FSD.md (Screen Display sections)

---

## Task 7.2: Create Theme & Styling
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** Material 3 color scheme, background, card, and primary-button themes are centralized in `lib/app.dart`.  
**Remaining:** Typography scale, spacing tokens, dark theme decision, component states, and visual QA.
**Priority:** P2 | **Effort:** S

Set up theming:
- lib/presentation/theme/app_colors.dart
- lib/presentation/theme/app_text_styles.dart
- lib/presentation/theme/app_theme.dart (light and dark themes)
- Implement accessibility color contrast

**Dependencies:** Task 6.1
**Related Docs:** IMPLEMENTATION_DETAILS.md (Accessibility section)

---

## Task 7.3: Implement Accessibility Support
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Continuous | **Updated:** 2026-07-23
**Evidence:** Semantic labels, selected state, live feedback, non-color indicators, ordered focus traversal, high-contrast theme, responsive layouts, and an automated 200% text-scale test are present.
**Remaining:** Manual TalkBack/VoiceOver audit, measured contrast report, full keyboard walkthrough, and platform accessibility-scanner testing.
**Priority:** P1 | **Effort:** M

Add accessibility features:
- Semantic labels on all interactive elements
- Screen reader support
- Text scaling (100-200%)
- High contrast mode support
- Keyboard navigation
- Tab order verification
- Test with accessibility scanner

**Dependencies:** Task 6.1-6.10, 7.1, 7.2
**Related Docs:** IMPLEMENTATION_DETAILS.md (Accessibility section)

---

# Phase 8: Testing & Quality Assurance

## Task 8.1: Create Unit Tests - Core Logic
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Continuous | **Updated:** 2026-07-20  
**Evidence:** Repository tests cover idempotent import, attempt recording, progress, and session restoration.  
**Remaining:** Controller and all future algorithm tests, edge cases, failure paths, and coverage reporting.
**Priority:** P1 | **Effort:** L

Write unit tests:
- 80% coverage of readiness score calculation
- 80% coverage of weak area analysis
- 80% coverage of metrics calculation
- 80% coverage of timer logic
- 80% coverage of all domain usecases
- Run: `flutter test --coverage`

**Dependencies:** Task 3.1-3.7
**Related Docs:** IMPLEMENTATION_DETAILS.md (Testing Requirements section)

---

## Task 8.2: Create Integration Tests - Core Flows
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Next milestone | **Updated:** 2026-07-20  
**Evidence:** In-memory database tests verify persistence behavior across repository operations.  
**Remaining:** Device-level `integration_test` coverage for complete practice, restart restoration, mock exam, and timer flows.
**Priority:** P1 | **Effort:** L

Write integration tests:
- Complete practice session flow (start → answer → finish)
- Timed exam flow with timer (start → answer → timer expiry → submit)
- Session persistence (close app → restore session → continue)
- Premium purchase flow
- Weak area analysis calculation

**Dependencies:** Task 5.1-5.5, 6.3-6.6
**Related Docs:** IMPLEMENTATION_DETAILS.md (Testing Requirements section)

---

## Task 8.3: Create Widget Tests - Screens
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Continuous | **Updated:** 2026-07-20  
**Evidence:** Home rendering, category import, and primary practice entry point are covered in `test/app_test.dart`.  
**Remaining:** Practice interactions, feedback, results, resume dialog, errors, responsive layout, and all future screens.
**Priority:** P2 | **Effort:** M

Write widget tests:
- Home screen rendering
- Practice question screen interaction
- Option selection flow
- Results screen display
- Progress metrics display
- Premium screen

**Dependencies:** Task 6.2-6.10
**Related Docs:** IMPLEMENTATION_DETAILS.md (Testing Requirements section)

---

## Task 8.4: Manual Testing Checklist
**Status:** PARTIAL | **Owner:** Project owner | **Target:** Continuous | **Updated:** 2026-07-22
**Evidence:** Project owner completed an Android emulator walkthrough covering star/unstar behavior and five-section navigation.
**Remaining:** Rotation, backgrounding, cold-start restoration, text scaling/screen reader, low disk, corruption recovery, timed-exam cases when available, and real Android/iOS devices.
**Priority:** P1 | **Effort:** M

Perform manual testing:
- Device rotation during quiz
- App backgrounding during practice
- Timer + backgrounding (timed exam)
- Session restoration on cold start
- Accessibility testing (screen reader, text scaling)
- Low disk space handling
- Database corruption recovery
- Network (if offline verification added)
- Test on real Android and iOS devices

**Dependencies:** All feature tasks
**Related Docs:** IMPLEMENTATION_DETAILS.md (Manual Testing Scenarios)

---

# Phase 9: Content & Data

## Task 9.1: Create Question Dataset Structure
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Content milestone | **Updated:** 2026-07-20  
**Evidence:** Draft 2020-12 schema and a 120-question bank contain stable question/option IDs, difficulty, per-option explanations, source editions, page references, lifecycle status, review metadata, and attribution.
**Remaining:** Editorial approval, final licensing review, and expansion if the 500+ content target is retained.
**Priority:** P0 | **Effort:** S

Set up JSON structure:
- Create assets/data/questions.json with 500+ questions
- Format per specification in DATABASE_SCHEMA.md
- Include all fields: text, options, correct answer, difficulty, category, explanation, reference
- Create sample data for testing (10-20 questions)

**Dependencies:** Task 2.7
**Related Docs:** PRD.md (Question Bank Requirements section)

---

## Task 9.2: Create Categories & Configuration
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Content milestone | **Updated:** 2026-07-20  
**Evidence:** Three database-driven categories and a versioned exam configuration asset exist under `assets/data/`.  
**Remaining:** Validate taxonomy against current official material and connect exam configuration to mock-exam logic.
**Priority:** P0 | **Effort:** S

Create supporting content:
- assets/data/categories.json (8 categories from official list)
- assets/data/exam_config.json (question count: 20, duration: 45 min, pass: 75%)
- assets/data/references.json (book references per question)

**Dependencies:** Task 2.7
**Related Docs:** PRD.md, FSD.md (Configuration sections)

---

## Task 9.3: Validate & Test Content Import
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Content milestone | **Updated:** 2026-07-20  
**Evidence:** Runtime validation covers required structure, duplicate IDs, category/source/replacement references, exactly four options, exactly one correct answer, display orders, and page ranges. Focused validation/import tests were added.
**Remaining:** Run the updated Flutter suite, add production-volume performance tests, and add user-facing recovery for invalid bundled content.
**Priority:** P1 | **Effort:** M

Verify data:
- Validate all 500+ questions parse correctly
- Verify 4 options per question
- Verify 1 correct answer per question
- Verify explanations exist
- Verify references complete
- Test database import performance (< 30 seconds)
- Verify data integrity post-import

**Dependencies:** Task 2.7, 9.1, 9.2
**Related Docs:** IMPLEMENTATION_DETAILS.md (Content Management section)

---

# Phase 10: Performance Optimization

## Task 10.1: Optimize Database Queries
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Final-content profiling | **Updated:** 2026-07-23
**Evidence:** Progress analytics and content/database operations record structured duration samples; normalized lookup indexes are present.
**Remaining:** EXPLAIN QUERY PLAN audit, final 500+ bank measurements, slow-query optimization, and caching only where measurements justify it.
**Priority:** P2 | **Effort:** M

Improve query performance:
- Verify all queries complete in < 100ms
- Check index usage with EXPLAIN QUERY PLAN
- Optimize slow queries
- Implement query result caching
- Test with 500+ questions

**Dependencies:** Task 2.8
**Related Docs:** IMPLEMENTATION_DETAILS.md (Performance Targets section)

---

## Task 10.2: Optimize App Launch Time
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Real-device profiling | **Updated:** 2026-07-23
**Evidence:** First-frame startup duration is captured and shown in Settings diagnostics.
**Remaining:** DevTools profile-mode baseline on target Android/iOS hardware and measured optimization against the 3-second target.
**Priority:** P2 | **Effort:** M

Reduce startup time:
- Profile app startup
- Target: < 3 seconds to home screen visible
- Lazy load features
- Pre-fetch home screen data in background
- Remove blocking operations
- Measure with DevTools

**Dependencies:** Task 6.1
**Related Docs:** IMPLEMENTATION_DETAILS.md (App Launch Time section)

---

## Task 10.3: Optimize Memory Usage
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Real-device profiling | **Updated:** 2026-07-23
**Evidence:** Resident memory is sampled cross-platform where supported and shown in Settings; repositories/controllers preserve bounded state.
**Remaining:** DevTools allocation/leak analysis under sustained use and verification of the 150 MB target on real devices.
**Priority:** P2 | **Effort:** M

Reduce memory footprint:
- Profile memory usage
- Target: < 150MB average
- Check for memory leaks
- Dispose widgets properly
- Clear caches appropriately
- Test with real questions dataset

**Dependencies:** All feature tasks
**Related Docs:** IMPLEMENTATION_DETAILS.md (Memory Usage section)

---

## Task 10.4: Performance Testing & Profiling
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Final-content profiling | **Updated:** 2026-07-23
**Evidence:** Structured performance samples cover startup, database creation/migration, content import, and Progress analytics.
**Remaining:** Document release baselines, profile question loading and sustained memory under the final bank, and add non-flaky regression thresholds.
**Priority:** P2 | **Effort:** M

Create performance tests:
- Measure app launch time
- Measure question load time
- Measure database query times
- Measure memory usage under load
- Document baseline metrics
- Create performance regression tests

**Dependencies:** Task 10.1-10.3
**Related Docs:** IMPLEMENTATION_DETAILS.md (Performance Targets section)

---

# Phase 11: Platform-Specific Implementation

## Task 11.1: Android Setup
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Platform milestone | **Updated:** 2026-07-21
**Evidence:** Android SDK 36, accepted licences, Android Studio, emulator detection, debug APK build, and emulator installation are verified.
**Remaining:** Manual emulator checklist, release signing, Play Billing setup, and real-device testing.
**Priority:** P1 | **Effort:** M

Configure Android:
- android/app/build.gradle (min SDK 21, target 34)
- AndroidManifest.xml (permissions)
- Set up Google Play Billing API
- Configure app signing
- Test on Android emulator and real device

**Dependencies:** Task 1.3
**Related Docs:** SAD.md (Tech Stack section)

---

## Task 11.2: iOS Setup
**Status:** PARTIAL | **Owner:** Unassigned | **Target:** Platform milestone | **Updated:** 2026-07-20  
**Evidence:** Standard iOS Flutter runner, Xcode project, assets, and tests are scaffolded.  
**Remaining:** Validate deployment target, bundle/signing configuration, permissions, icons, simulator build, and real-device testing on macOS.
**Priority:** P1 | **Effort:** M

Configure iOS:
- ios/Podfile (deployment target iOS 12.0+)
- Set up Apple In-App Purchases
- Configure provisioning profiles
- Configure code signing
- Test on iOS simulator and real device

**Dependencies:** Task 1.3
**Related Docs:** SAD.md (Tech Stack section)

---

## Task 11.3: In-App Purchase Implementation
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Premium milestone | **Updated:** 2026-07-20
**Priority:** P1 | **Effort:** M

Implement purchases:
- lib/data/services/purchase_service.dart
- Integrate Google Play Billing (Android)
- Integrate Apple In-App Purchases (iOS)
- Handle purchase flow
- Handle restore purchases
- Verify purchases
- Add error handling

**Dependencies:** Task 5.5, 11.1, 11.2
**Related Docs:** PRD.md (Monetization section)

---

# Phase 12: Deployment & Release

## Task 12.1: Prepare Google Play Store Release
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Release milestone | **Updated:** 2026-07-20
**Priority:** P2 | **Effort:** M

Prepare Android release:
- Create Google Play Developer account
- Generate upload key
- Create signed APK
- Write app description and screenshots
- Set up store listing
- Configure pricing
- Create release build

**Dependencies:** Task 11.1, 8.4
**Related Docs:** IMPLEMENTATION_DETAILS.md (Deployment section)

---

## Task 12.2: Prepare Apple App Store Release
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Release milestone | **Updated:** 2026-07-20
**Priority:** P2 | **Effort:** M

Prepare iOS release:
- Create Apple Developer account
- Create app in App Store Connect
- Generate provisioning profiles
- Create signing certificates
- Write app description and screenshots
- Set up store listing
- Configure pricing
- Create release build

**Dependencies:** Task 11.2, 8.4
**Related Docs:** IMPLEMENTATION_DETAILS.md (Deployment section)

---

## Task 12.3: Create Release Documentation
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Release milestone | **Updated:** 2026-07-20
**Priority:** P2 | **Effort:** S

Prepare docs:
- Create RELEASE_NOTES.md for v1.0.0
- Create PRIVACY_POLICY.md
- Create TERMS_OF_SERVICE.md
- Create USER_GUIDE.md (optional, for future)
- Document support contact

**Dependencies:** Task 12.1, 12.2
**Related Docs:** IMPLEMENTATION_DETAILS.md (Deployment section)

---

## Task 12.4: Beta Testing & App Review
**Status:** NOT STARTED | **Owner:** Unassigned | **Target:** Release milestone | **Updated:** 2026-07-20
**Priority:** P2 | **Effort:** M

Test before release:
- Google Play internal testing track
- Apple TestFlight beta testing
- Gather feedback from beta testers
- Fix critical issues
- Submit to stores for review
- Respond to review feedback

**Dependencies:** Task 12.1, 12.2
**Related Docs:** IMPLEMENTATION_DETAILS.md (Deployment Checklist)

---

# Dependency Graph Summary

```
Phase 1: Project Setup (1.1-1.4)
    ↓
Phase 2: Database (2.1-2.8)
    ↓
Phase 3: Core Logic (3.1-3.7)
    ↓
Phase 4: State Management (4.1-4.3)
    ↓
Phase 5: Features (5.1-5.6)
    ↓
Phase 6: UI Screens (6.1-6.10)
    ↓
Phase 7: UI Components (7.1-7.3)
    ↓
Phase 8: Testing (8.1-8.4)
    ↓
Phase 9: Content (9.1-9.3)
    ↓
Phase 10: Optimization (10.1-10.4)
    ↓
Phase 11: Platform Setup (11.1-11.3)
    ↓
Phase 12: Deployment (12.1-12.4)
```

---

# Task Priority for MVP

**Must Complete for MVP (P0 & P1):**
- All Phase 1, 2, 3, 4 tasks
- Phase 5: 5.1-5.6
- Phase 6: 6.1-6.10
- Phase 7: 7.1-7.3
- Phase 8: 8.1-8.3
- Phase 9: 9.1-9.3
- Phase 11: 11.1-11.3
- Phase 12: 12.1-12.4

**Nice to Have (P2):**
- Phase 8: 8.4 (manual testing - still important for quality)
- Phase 10: 10.1-10.4
- Phase 12: 12.3

---

# Effort Summary

| Phase | Tasks | Total Effort |
|-------|-------|--------------|
| 1: Setup | 4 | ~4M |
| 2: Database | 8 | ~7L |
| 3: Core Logic | 7 | ~6L |
| 4: State Mgmt | 3 | ~3M |
| 5: Features | 6 | ~6L |
| 6: UI Screens | 10 | ~10L |
| 7: Components | 3 | ~3M |
| 8: Testing | 4 | ~4L |
| 9: Content | 3 | ~2M |
| 10: Optimization | 4 | ~4M |
| 11: Platform | 3 | ~3M |
| 12: Deployment | 4 | ~3M |

**Total MVP Estimate: ~50 weeks (assuming 1 person, ~40 hours/week development)**
**With team of 2-3 people working in parallel: ~15-20 weeks**

---

# How to Use This Backlog

1. **Select from Next Up** - Prefer the ordered queue unless priorities or dependencies change.
2. **Assign an Owner** - Replace `Unassigned` before implementation starts.
3. **Set In Progress** - Record the intended target and update date.
4. **Keep Evidence Current** - Add implementation and test paths as acceptance items land.
5. **Use Partial Honestly** - Do not mark a broad task complete when only a vertical-slice subset exists.
6. **Record Blockers** - State the external condition, owner, and next unblock action.
7. **Complete with Verification** - Confirm every task bullet, tests, and relevant manual checks.
8. **Update the Dashboard** - Recount all 59 tasks whenever a status changes.
9. **Reference Task IDs** - Include task IDs in commits and pull requests.

---

# Tracker Change Log

| Date | Change | Verification |
|---|---|---|
| 2026-07-24 | Added persisted timed premium exams, lifecycle-safe recovery, timeout submission, readiness scoring, weak-area analysis, prioritized recommendations, and exam trends. | Analysis clean; all 30 automated tests passed; Android debug APK built. |
| 2026-07-23 | Added free Progress analytics, release-ready Settings information/controls, difficulty filters, direct unstar, exam history/review, archived-question safeguards, accessibility improvements, and runtime diagnostics. | Analysis clean; all 18 automated tests passed, including 200% activity-chart scaling, history reconstruction, and progress reset preservation. |
| 2026-07-23 | Added named stateful navigation, saved-session back handling, typed recovery paths, and the completed free Home dashboard. | Analysis clean; all 14 automated tests passed; Android debug APK built. |
| 2026-07-23 | Added the production question-bank schema, normalized content pipeline, safe update/removal lifecycle, option explanations, source references, and stable answer IDs. | JSON integrity audit passed for 120 questions and 480 options; analysis clean; all 11 tests passed. |
| 2026-07-22 | Added the configuration-driven free untimed mock-exam vertical slice and schema-v3 persistence. | Analysis clean; all 9 tests passed; Android debug APK built. |
| 2026-07-22 | Added multi-category selection and configurable practice length; recorded user-completed emulator checks and reprioritized the queue. | Analysis clean; all 7 automated tests passed. |
| 2026-07-21 | Added Android debug-build/install evidence, persistent starred questions, five-section navigation, Practice hub, and basic Progress screen; reprioritized the next-up queue. | `flutter doctor` clean; analysis clean; debug APK installed on emulator; all 5 automated tests passed. |
| 2026-07-20 | Converted the implementation plan into a 59-task tracker with explicit status, ownership, targets, evidence, remaining work, dashboard totals, and next-up ordering. | Status metadata count and dashboard totals validated. |
| 2026-07-20 | Recorded Milestone 1 implementation and the Android SDK environment blocker. | `flutter analyze` passed; all 3 automated tests passed; Android build stopped at missing SDK. |

---

**Questions?** Refer to AGENTS.md for quick navigation to relevant documentation.
