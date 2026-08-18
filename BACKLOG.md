# Pass Australian Citizenship Test backlog

The original implementation backlog was reviewed and archived on 2026-07-30.
Its complete task history and acceptance record are preserved in
[`BACKLOG_ARCHIVE_2026-07-30.md`](BACKLOG_ARCHIVE_2026-07-30.md).

This file is the authoritative tracker for the current release-readiness cycle.
It contains only unfinished work, including findings from physical Android
device testing.

Status legend: `TODO` | `IN PROGRESS` | `BLOCKED` | `PARTIAL` | `DONE`

Priority legend: `P0` release blocker | `P1` required before release |
`P2` polish or maintainability

Last updated: 2026-08-18.

## Current delivery cycle: MVP release readiness

**Theme:** Complete and validate the content, resolve physical-device feedback,
prove quality on Android and iOS, and prepare signed store releases.

**Overall status:** `IN PROGRESS` — RR-01 through RR-07 are `DONE`.
**Both platforms are live**: Android on Google Play since 2026-08-13,
iOS on the App Store since 2026-08-18. Version 1.0.0 has shipped. Only
archiving this backlog remains on RR-08.

### Release-readiness outcome

Deliver a production-ready version 1.0.0 that:

1. Contains at least 400 reviewed and validated citizenship questions.
2. Presents readable, accessible study and exam experiences in light and dark
   modes.
3. Preserves practice and exam state across supported lifecycle events.
4. Meets the documented accessibility targets.
5. Installs as signed Android and iOS release candidates.
6. Completes internal beta testing with no open critical defects.

### Scope baseline

In scope:

- Resolution and re-verification of all recorded Android physical-device
  feedback.
- Expansion and review of the production question bank.
- Device-level integration tests for critical practice and exam flows.
- Android and iOS physical-device and accessibility validation.
- Remaining release-critical UI and failure-state polish.
- Android and iOS signing, store metadata, beta testing, and submission.
- Release documentation, privacy declarations, and support information.

Out of scope:

- Backend infrastructure, authentication, accounts, or cloud synchronization.
- Advertisements, subscriptions, purchases, or feature gating.
- Web release for version 1.0.0.
- Direct in-app reproduction of the official citizenship booklet.
- New study modes or analytics beyond the approved MVP.
- Architecture refactoring that does not materially improve release safety.
- Dedicated release profiling, battery measurement, memory-leak analysis, and
  performance-baseline work for version 1.0.0.

### Approved product decisions

| Decision | MVP behavior |
| --- | --- |
| Feature access | Every study feature remains free and available without entitlement checks. |
| Orientation | The mobile app remains in portrait orientation. |
| Question bank | The retained MVP target is at least 400 reviewed questions. |
| Official course material | Provide an external link to the current official “Australian Citizenship: Our Common Bond” resource. |
| External links | Open externally, remain optional, and show a safe retry/error state on failure. |
| Offline behavior | Core study features continue to work without a network connection. |
| Exam rules | Use bundled configuration; select exactly five Australian values questions and require both the overall pass mark and 5/5 values. |
| Release platforms | Android and iOS are required for version 1.0.0; web is deferred. |

## Workflow and tracking rules

1. Work packages execute in the order shown unless this backlog records an
   approved exception.
2. Only one package should normally be `IN PROGRESS` at a time.
3. A checked item means its acceptance evidence exists. Partial implementation
   remains unchecked and is described in Notes.
4. A package becomes `DONE` only after its implementation, automated
   verification, applicable manual checks, and evidence are complete.
5. Physical-device fixes must be re-tested on a physical device before they are
   marked complete.
6. Update this backlog after each package, including completion date, test
   results, device evidence, and relevant paths.
7. Release preparation does not begin until unresolved P0 content, functional,
   accessibility, and device defects are cleared.

## Current focus

RR-01 through RR-07 are `DONE`. Both platforms are live: Android since
2026-08-13, iOS since 2026-08-18. Version 1.0.0 has shipped. The only
remaining step is archiving this backlog.

## Ordered release-readiness work packages

### RR-01 — Resolve Android physical-device feedback

**Status:** `DONE`

**Priority:** `P0`

**Depends on:** Core MVP feature implementation — satisfied.

**Started:** 2026-07-30.

**Completion:** 2026-08-03. Implementation and automated verification
completed 2026-07-31; the owner completed physical-device re-testing of all
fourteen findings on 2026-08-03.

- [x] **AND-01 — Block device rotation.** Lock the mobile app to portrait and
      confirm rotation cannot interrupt or visually corrupt an active practice
      or exam session.
- [x] **AND-02 — Fix exam question and option styling in dark mode.** Replace
      the unreadable white treatment with theme-aware cards comparable to the
      Practice selections such as “All Categories” and “Australia and its
      people.” Preserve distinct selected, answered, correct, incorrect, and
      disabled states.
- [x] **AND-03 — Fix wrong-answer explanation visibility in dark mode.** Make
      the explanation background, heading, body, and icons readable in both
      themes with WCAG AA contrast.
- [x] **AND-04 — Add spacing below the wrong-answer explanation.** Add a clear,
      consistent gap between the explanation panel and the Next Question button
      so the panel does not appear to continue below its visible edge.
- [x] **AND-05 — Remove Questions and Starred statistic tiles from Home.**
      Remove both tiles and reflow the surrounding layout without empty or
      uneven space.
- [x] **AND-06 — Correct the Home heading hierarchy.** Make the screen heading
      more prominent than the first content text and consistent with other
      primary screens at 100–200% text scale.
- [x] **AND-07 — Home branding experiment superseded.** The initially added app
      mark was removed by the later AND-11 device feedback.
- [x] **AND-08 — Add the official “Our Common Bond” link.** The current
      government resource opens externally with safe failure handling. Its
      final placement is governed by AND-09.
- [x] **AND-09 — Move the “Our Common Bond” link to Source and disclaimer.**
      Remove the link from Home and make the existing Settings source card open
      the official course content.
- [x] **AND-10 — Correct heading hierarchy across all screens.** Use a
      consistent, more prominent application-bar heading style throughout the
      app.
- [x] **AND-11 — Remove the Home image.** Remove the app mark introduced during
      the initial AND-07 implementation.
- [x] **AND-12 — Fix remaining dark-mode result and insight cards.** Make Strong
      areas, Needs attention, completed exam history, current answer review, and
      historical answer review use theme-aware surfaces and foreground colours.
- [x] **AND-13 — Style dialog actions consistently.** Render secondary and
      primary actions as a balanced two-column button row in every application
      dialog, avoiding the oversized stacked layout on narrow phones.
- [x] **AND-14 — Start question progress indicators at zero.** Practice progress
      advances after the current answer is submitted; exam progress reflects
      the number of answered questions rather than the current page.
- [x] **AND-15 — Remove Page number references from answer description.** Currently
      when the question is answered in practice session, the details appear which
      include at which page number the question details can be found in the 
      our-common-bond book, please remove just the page number and keep everything
      else there.
- [x] Add focused automated tests for the changed orientation, theme, layout,
      Home, and external-link behavior.
- [x] Re-test all fourteen findings on a physical Android device in light and dark
      modes.

Acceptance criteria:

- The app stays in portrait throughout normal use and active sessions.
- Exam questions, options, feedback, and explanations remain readable in light
  and dark modes.
- Explanation spacing remains clear on small screens and at 200% text scale.
- Home contains neither removed statistic tile nor the superseded image and has
  an intentional visual hierarchy.
- The Settings Source and disclaimer card links to the current official booklet
  resource, opens externally, and fails safely.
- All primary screen headings use the same prominent hierarchy.
- Progress insight cards, exam history, and answer reviews remain readable in
  light and dark modes.
- Dialog secondary actions render as buttons rather than text links.
- Question progress begins at zero and advances only as questions are answered.
- All affected automated tests pass and every device finding has recorded
  physical-device verification.

Evidence:

- Portrait lock: `android/app/src/main/AndroidManifest.xml` and `lib/main.dart`.
- Theme-aware exam options:
  `lib/features/exams/presentation/exam_screen.dart`.
- Theme-aware Practice options, feedback, and spacing:
  `lib/features/practice/presentation/practice_screen.dart`.
- Home tile/image removal and booklet-action removal:
  `lib/features/practice/presentation/home_screen.dart`.
- Application-wide heading hierarchy: `lib/core/theme/app_theme.dart`.
- Dark-mode Progress insights and exam history/reviews:
  `lib/features/progress/presentation/progress_screen.dart`,
  `lib/features/exams/presentation/exam_history_screen.dart`,
  `lib/features/exams/presentation/exam_review_screen.dart`, and
  `lib/features/exams/presentation/exam_history_detail_screen.dart`.
- Consistent dialog action row:
  `lib/shared/presentation/dialog_action_buttons.dart`, used by Home, Practice,
  Exams, active Exam, and Settings presentation files.
- Narrow-phone dialog layout coverage:
  `test/dialog_action_buttons_test.dart`.
- Zero-based Practice and Exam progress indicators:
  `lib/features/practice/presentation/practice_screen.dart` and
  `lib/features/exams/presentation/exam_screen.dart`.
- Official booklet URI, external launch, and failure handling:
  `lib/features/settings/data/settings_repository.dart` and
  `lib/features/settings/presentation/settings_screen.dart`.
- Focused Home and official-URI assertions: `test/app_test.dart` and
  `test/settings_repository_test.dart`.
- The official Home Affairs page and booklet description were verified on
  2026-07-30.
- `git diff --check` passed.
- `flutter analyze --no-pub` passed with no issues on 2026-07-31.
- The complete Flutter test suite passed 34/34 tests on 2026-07-31.
- `flutter build apk --debug --no-pub` produced
  `build/app/outputs/flutter-apk/app-debug.apk` on 2026-07-31.
- The owner confirmed physical-device re-testing of all fourteen findings, in
  both light and dark modes, on 2026-08-03.

Notes:

- These findings came from physical Android testing supplied by the project
  owner on 2026-07-30.
- No finding is considered resolved solely from emulator or widget-test
  evidence.

### RR-02 — Complete and approve the production question bank

**Status:** `DONE`

**Priority:** `P0`

**Depends on:** Existing question schema and import validation — satisfied.

**Started:** 2026-08-02.

**Completion:** 2026-08-03. Bank expanded from 120 to 421 questions and passes
all automated validation. Facts and taxonomy were validated against the
current official booklet and confirmed complete by the owner on 2026-08-02.
The owner reviewed and approved all 421 questions via the
[`question-review.html`](question-review.html) tool and confirmed the
attribution/licensing notice on 2026-08-03.

- [x] Expand the current 120-question bank to at least 400 questions.
- [x] Preserve stable question and option IDs.
- [x] Give every question exactly four options and one correct answer.
- [x] Complete correct-answer and incorrect-option explanations.
- [x] Assign and validate category and difficulty metadata.
- [x] Validate facts and taxonomy against the current official booklet.
- [x] Verify source edition, section, page, and lifecycle metadata.
- [x] Complete editorial, attribution, and licensing review.
- [x] Run schema, duplicate, option, reference, and import validation.
- [x] Measure import and query performance at final production volume.

Acceptance criteria:

- The bundled bank contains at least 400 unique, active, reviewed questions.
- Every question passes automated structural and import validation.
- Editorial approval confirms factual accuracy and readable explanations.
- References and attribution are suitable for release.
- Final-bank import and common queries meet performance targets.

Evidence:

- `assets/data/questions.json` now contains 421 questions (up from 120):
  people 97, beliefs 76, government 168, values 80 (80 of which are marked
  `isAustralianValuesQuestion`).
- All 301 new questions were drafted directly from the owner-supplied
  `our-common-bond-testable.pdf` (the 2020 "Our Common Bond" testable
  section, Parts 1-4 and glossary) and cite a specific `part`/`chapter`/
  `section`/`pageStart`/`pageEnd` in `sourceReferences` for every question.
- Every question has exactly 4 options, exactly 1 correct answer, and a
  per-option explanation; `lib/features/practice/data/question_bank_validator.dart`
  (the same validator the app runs at import) was executed against the full
  421-question bank via a temporary Dart test and passed with zero errors.
- No duplicate question text and no ID collisions across the 421 questions
  (checked programmatically); new IDs extend the existing per-category
  numbering (`question-p31`…, `question-b31`…, `question-g31`…,
  `question-v31`…) without touching the original 120.
- `questionBankVersion` bumped to `1.1.0-beta.1` and `generatedAt` updated in
  `assets/data/questions.json`.
- Import/query performance at the 421-question volume, measured via a
  temporary Dart test: JSON parse ~47ms, schema validation ~26ms,
  category/values-pool query ~2ms — well within acceptable bounds for a
  bundled offline asset.
- `flutter analyze --no-pub` passed with no issues on 2026-08-02.
- The complete Flutter test suite passed 44/44 on 2026-08-02 after updating
  two tests (`test/practice_repository_test.dart`) that hard-coded the old
  120-question bundle count to the new 421.
- The owner confirmed on 2026-08-02 that factual and taxonomy validation
  against the current official booklet is complete.
- The owner reviewed and approved all 421 questions individually via
  `question-review.html` on 2026-08-03; every question now carries
  `status: approved`, `review.status: approved`, and true source, wording,
  answer, and explanation verification flags in
  `assets/data/questions.json`.
- The owner confirmed on 2026-08-03 that the CC BY 4.0 attribution notice
  (`attribution.licenceName`/`copyrightNotice`/`licenceUrl` in
  `assets/data/questions.json`, rendered live in Settings → Source via
  `lib/features/settings/data/settings_repository.dart` and
  `lib/features/settings/presentation/settings_screen.dart`) correctly credits
  the source, links the licence, and discloses that the question wording is
  an adaptation, and that this bank-level notice covers the expanded
  421-question bank.

Notes:

- The `questions-backup.json` asset is an older, unrelated 12-question dev
  artifact and was not touched.
- `sourceEditions[0].checksum` in `assets/data/questions.json` still reflects
  an earlier hashing of the source PDF and was not re-verified against
  `our-common-bond-testable.pdf` as part of this sign-off; flagged for
  awareness only, not blocking, per owner decision on 2026-08-03.

### RR-03 — Add critical-flow integration and coverage evidence

**Status:** `DONE`

**Priority:** `P0`

**Depends on:** RR-01 for final UI expectations; RR-02 for production-volume
coverage — both satisfied (421 approved questions).

**Completion:** 2026-08-05. All 10 checklist items complete and all
automated coverage work is done at production question-bank volume. Per
owner decision on 2026-08-05, this package is closed without executing
`integration_test/critical_flows_test.dart` on physical Android or iOS
hardware — it has only been run on Windows desktop and in the development
environment. This is a deliberate, explicit exception to this backlog's
own workflow rule 5 ("Physical-device fixes must be re-tested on a
physical device before they are marked complete"); it is not a claim that
device execution happened.

- [x] Add device-level integration coverage for a complete practice session.
- [x] Cover timed and untimed mock exams.
- [x] Cover timer backgrounding, resume, expiry, and auto-submit.
- [x] Cover cold-start practice and exam restoration.
- [x] Cover backwards device-clock detection and lock behavior.
- [x] Cover invalid content and database recovery behavior.
- [x] Add focused Practice interaction and recovery-state tests.
- [x] Add dedicated Settings, history, and starred-screen widget tests.
- [x] Add remaining controller, edge-case, and failure-path tests.
- [x] Generate and record an automated coverage report.

Acceptance criteria:

- Critical practice and exam workflows pass on supported device targets.
- Lifecycle and recovery scenarios are deterministic and repeatable.
- Failure paths present documented, user-safe states.
- The project has recorded progress against its 80% unit-test coverage target.
- Static analysis and the complete automated suite pass.

Evidence:

- `integration_test/critical_flows_test.dart` covers complete Practice, timed
  and untimed exams, controller recreation, timer background/resume/expiry,
  backwards-clock locking, removed-content recovery, and — newly added —
  corrupted local database recovery: a real file-backed database is seeded
  with the imported bundled bank, its bytes are overwritten to simulate
  on-disk corruption, opening it is confirmed to surface a recoverable
  `StorageFailure` (`canRetry: true`), and the standard
  close-delete-reopen-reimport recovery path is confirmed to restore a fully
  working, fully-imported question bank.
- `test/exam_flow_widget_test.dart` (new) drives a complete mock-exam journey
  through the real app (real router, real screens, real in-memory database):
  starting an exam, answering a mix of correct/incorrect/unanswered
  questions, using the question navigator, submitting, reviewing results,
  reviewing individual answers, and inspecting exam history and history
  detail. This alone took `exam_screen.dart` from 0.8% to 83.8% line
  coverage, `exams_home_screen.dart` from 1.1% to 82.2%, and
  `exam_history_detail_screen.dart` from 0% to 85.2%.
- `test/rr03_widget_test.dart` covers Practice feedback and recovery states,
  Settings data and failure states, starred-question states, and exam history.
- `test/controller_edge_cases_test.dart` covers ignored Practice and Exam
  actions, empty starred sessions, inactive restore, and locked-exam input.
- The device-level integration suite passed 7/7 flows on Windows on
  2026-08-03 (including the new corrupted-database recovery test).
- The complete unit/widget suite passed 45/45 tests on 2026-08-03.
- `flutter analyze --no-pub` passed with no issues on 2026-08-03.
- `coverage/lcov.info`, regenerated at the full 421-question production
  volume, records 3,155 of 5,834 lines hit (54.08% raw). Excluding
  `lib/data/database/app_database.g.dart` (drift-generated boilerplate —
  2,553 lines, 30.4% covered, standard practice to exclude generated code
  from hand-written-coverage targets), hand-written source coverage is
  2,379 of 3,281 lines (72.51%), up from the prior 45.82% baseline.

Notes:

- Coverage is recorded and has improved substantially at production volume,
  satisfying the acceptance criterion as written ("has recorded progress
  against its 80% ... target"), but 72.51% (hand-written) / 54.08% (raw) is
  short of the literal 80% figure. Closing the remainder would mean adding
  comparable flow coverage for `progress_screen.dart` (40.4%),
  `home_screen.dart` (40.8%), `settings_screen.dart` (54.9%), and
  `app_database.dart` (24.6%, hand-written DB helper code) — a further
  session of similar scope to this one.
- The integration suite has not been executed on physical Android or iOS
  hardware. Per owner decision on 2026-08-05, this is waived rather than
  outstanding — see Completion above.
- Coverage is recorded but remains below the 80% project target.

### RR-04 — Complete physical-device and accessibility validation

**Status:** `DONE`

**Priority:** `P0`

**Depends on:** RR-01 and RR-03.

**Completion:** 2026-08-05. All 11 checklist items resolved. The owner
completed the listed Android/iOS lifecycle, recovery, scaling, navigation,
contrast, and scanner checks. TalkBack and VoiceOver walkthroughs are
explicitly omitted from the MVP requirement. The colour/animation
independence audit found and fixed one real issue in `practice_screen.dart`.

- [x] Test timed-exam backgrounding, expiry, auto-submit, and restoration.
- [x] Test app termination and cold-start restoration.
- [x] Test supported Android physical devices and record device/OS details.
- [x] Test supported iOS physical devices and record device/OS details.
- [x] Test low-storage behavior, corrupted database recovery, invalid bundled
      content, and external-link failures.
- [x] TalkBack and VoiceOver walkthroughs are not required for the MVP, per
      owner decision on 2026-08-02.
- [x] Verify the primary flows at 100–200% text scaling.
- [x] Complete keyboard and focus-navigation checks where applicable.
- [x] Measure WCAG AA contrast in light and dark modes.
- [x] Run Android and iOS accessibility scanners.
- [x] Confirm no required information depends on animation or colour alone.

Acceptance criteria:

- Every documented manual scenario has device, OS, result, and defect evidence.
- No open critical or serious accessibility defect remains.
- Practice and exam state survives all documented supported lifecycle events.
- Recovery behavior matches the functional and implementation documentation.

Evidence:

- Owner-confirmed manual Android and iOS validation on 2026-08-02 covered
  timer backgrounding, expiry, auto-submit, restoration, and cold starts.
- Owner-confirmed recovery validation covered low storage, corrupted content,
  invalid bundled content, and external-link failures.
- Owner-confirmed accessibility validation covered 100–200% text scaling,
  keyboard/focus navigation, WCAG AA contrast, and platform accessibility
  scanners.
- TalkBack and VoiceOver manual walkthroughs were explicitly removed from the
  MVP validation requirement by owner decision on 2026-08-02.
- A full audit of every screen under `lib/features/*/presentation/` and
  `lib/shared/presentation/` for WCAG 1.4.1 (Use of Color) was completed
  2026-08-05: every color-coded state found (correct/incorrect, pass/fail,
  selected/starred, category performance bands, etc.) is paired with a
  redundant icon or text label, with one exception. A repo-wide search for
  `AnimationController`/`AnimatedContainer`/`TweenAnimationBuilder`/etc.
  found no bespoke meaning-carrying animations (only default Flutter
  progress indicators and page transitions), so there was nothing to fix
  on the animation side.
- The one exception found: `lib/features/practice/presentation/practice_screen.dart`'s
  answer-option list distinguished the correct option and the user's wrong
  pick from other options using background/border color alone, with no
  icon (unlike the equivalent exam-review and exam-history-detail screens,
  which already pair color with a check/cross icon per option). Fixed by
  adding the same `check_circle`/`cancel`/`radio_button_unchecked` icon
  pattern to each option once answered, and updating the option's
  `Semantics` label to state correctness explicitly for screen readers.
- `flutter analyze --no-pub` passed with no issues and the complete test
  suite passed 45/45 after the fix, on 2026-08-05.

### RR-06 — Finish release-critical product and technical polish

**Status:** `DONE`

**Priority:** `P2`

**Depends on:** RR-01 and RR-03.

**Completion:** 2026-08-06. All 8 checklist items resolved.

- [x] Keep the system-controlled theme; no separate persisted theme preference
      is required for the MVP.
- [x] Remove notification settings from the MVP.
- [x] Complete responsive visual QA.
- [x] Practice exit, saved-position, retry, and documented failure states are
      implemented and covered by the existing automated suite.
- [x] A separate Terms of Service is not required for the MVP. Retain the
      privacy policy and its study-content/results disclaimer.
- [x] Remove repository splitting and nonessential architecture cleanup from
      the MVP.
- [x] Treat the implemented database schema as authoritative for version 1.0.0
      and defer nonessential differences from `docs/DATABASE_SCHEMA.md`.
- [x] Defer production upgrade-path and migration tests until after version
      1.0.0.

Acceptance criteria:

- Every retained setting is functional, persisted where required, and tested.
- Primary screens pass responsive visual QA.
- No unresolved product decision blocks store submission.
- Architecture cleanup does not expand MVP scope or regress existing data.

Evidence:

- `lib/app.dart` uses `ThemeMode.system`; owner decision on 2026-08-02 confirms
  no separate theme preference is required.
- Owner decision on 2026-08-02 excludes notifications, repository splitting,
  nonessential schema reconciliation, and pre-1.0 migration tests from scope.
- Practice exit, retry, restoration, and failure behavior is implemented and
  covered by the existing automated suite.
- `PRIVACY.md` includes the required unofficial-study-aid, content-error,
  own-risk, and test-results disclaimer.
- Responsive visual QA was completed 2026-08-06 by running the app via
  `flutter run -d windows` and resizing the window across ~360px (small
  phone), ~430px (large phone, matching the physical Android/iOS devices
  already smoke-tested), and ~800px+ (tablet-width) breakpoints. Every
  primary screen (Home, Practice, Practice results, Exams, Exam session,
  Exam review, Exam history and detail, Progress, Starred, Settings) was
  checked for text truncation/overflow, clipped or overlapping controls,
  and the answer-feedback panel's longer explanation/citation text
  reflowing correctly. No issues found.

### RR-07 — Prepare signed Android and iOS releases

**Status:** `DONE`

**Priority:** `P0`

**Depends on:** RR-04 and all release-blocking RR-06 decisions.

**Started:** 2026-08-03.

**Completion:** 2026-08-08. Both platforms produce signed release builds
and have been installed and smoke-tested on physical devices via both
their normal distribution channel and a direct/sideloaded build.
Store listings (descriptions, screenshots, feature graphic, categories,
pricing, and privacy/data-safety declarations) are complete for both
Google Play and the App Store. All 7 checklist items are done.

- [x] Configure Android release signing. Owner generated
      `upload-keystore.jks` via `keytool` on 2026-08-04.
      `android/key.properties` (gitignored) holds the store/key passwords
      and alias; `android/app/build.gradle.kts` was updated with a
      `signingConfigs.release` block read from that file, falling back to
      debug signing if the file is absent (e.g. a fresh checkout without the
      release key) so `flutter run --release` keeps working for anyone
      without it.
- [x] Validate Android application ID, SDK settings, permissions, icons, and
      production build configuration. `applicationId`/`namespace` changed
      from the placeholder-adjacent `au.com.passcitizenship.*` (a domain the
      owner does not control) to `com.hashamahmad.pass_citizenship_test`,
      per owner decision on 2026-08-03. Manifest permissions, SDK versions,
      and launcher icons were reviewed and are already production-ready
      (custom branded icon, no unnecessary permissions, Flutter-managed SDK
      versions).
- [x] Build, install, and smoke-test a signed Android release candidate.
      `app-release.apk` installed cleanly via `adb install` on a physical
      Redmi Note 9 Pro (Android 10, API 29) on 2026-08-04. App launched
      without crashing, Home dashboard rendered correctly with real bundled
      data, Practice showed "Question 1 of 421" confirming the full
      production question bank imported correctly, and answering a question
      showed the correct theme-aware feedback panel with explanation and
      source citation. No FATAL/AndroidRuntime exceptions in logcat.
- [x] Configure the iOS bundle ID, certificates, provisioning, deployment
      target, permissions, icons, and production build on macOS. Bundle ID
      renamed to match Android (`com.hashamahmad.passCitizenshipTest`).
      With no Mac available, the owner enrolled Appitome Technologies Pty
      Ltd in the Apple Developer Program, generated an Apple Distribution
      certificate and an App Store provisioning profile via the Apple
      Developer web portal (certificate CSR generated locally with
      OpenSSL, no Mac needed), and a GitHub Actions `macos-latest` workflow
      was built to consume them — see Evidence.
- [x] Build, install, and smoke-test a signed iOS release candidate.
      Built, signed, and uploaded via GitHub Actions, installed via
      TestFlight on a physical iPhone, and smoke-tested by the owner on
      2026-08-06 (see Evidence).
- [x] Prepare Google Play and App Store descriptions, screenshots, categories,
      pricing, declarations, and privacy metadata. Both store listings are
      fully filled in (see Evidence); Android's first Play-signed build was
      also uploaded to Internal testing and smoke-tested successfully.
- [x] Confirm every feature is described as free and no entitlement or billing
      setup is required. Both stores are configured with Free pricing and no
      in-app purchases; the App Privacy / Data Safety questionnaires both
      declare no data collection, matching `PRIVACY.md`.

Acceptance criteria:

- Signed Android and iOS release candidates install and complete smoke tests on
  physical devices.
- Store metadata accurately describes the implemented application.
- Privacy, permission, content, and external-link declarations are complete.
- No development-only branding, configuration, or diagnostics leak into the
  release experience.

Evidence:

- `android/app/build.gradle.kts`, `android/app/src/main/kotlin/com/hashamahmad/pass_citizenship_test/MainActivity.kt`,
  `ios/Runner.xcodeproj/project.pbxproj`, `macos/Runner.xcodeproj/project.pbxproj`,
  and `macos/Runner/Configs/AppInfo.xcconfig` all updated to the new
  `com.hashamahmad.*` identifier on 2026-08-03.
- `flutter build apk --debug --no-pub` succeeded with the renamed package;
  the packaged manifest was confirmed to carry
  `com.hashamahmad.pass_citizenship_test`.
- `flutter analyze --no-pub` passed with no issues and the complete test
  suite passed 45/45 after the rename, on 2026-08-03.
- `android/key.properties` (gitignored, not committed) and a
  `signingConfigs.release` block in `android/app/build.gradle.kts`, added
  2026-08-04.
- `flutter build apk --release` produced
  `build/app/outputs/flutter-apk/app-release.apk` (54.1MB) and
  `flutter build appbundle --release` produced
  `build/app/outputs/bundle/release/app-release.aab` (43.8MB) on 2026-08-04.
- `apksigner verify --print-certs app-release.apk` confirmed the APK is
  signed with the owner's release certificate (`CN=Hasham Ahmad, OU=ASD,
  O=Appitome Technologies, L=Sydney, ST=NSW, C=AU`), not the Flutter debug
  certificate.
- Apple Developer Program enrollment (Appitome Technologies Pty Ltd, Team
  ID `GA9WWQPRAU`) confirmed active 2026-08-04. App ID
  `com.hashamahmad.passCitizenshipTest` registered with no extra
  capabilities (the app needs none). An Apple Distribution certificate and
  an "App Store" provisioning profile ("Pass Citizenship Test App Store")
  were created via the Apple Developer web portal; the certificate's CSR
  and private key were generated locally with OpenSSL, so no Mac was
  required at any point in this process.
- `.github/workflows/ios-release.yml` (new, `workflow_dispatch`-triggered,
  `runs-on: macos-latest`) imports the certificate and provisioning
  profile from 5 repository secrets into a temporary keychain — including
  explicitly importing Apple's WWDR intermediate CA certificates, without
  which `security find-identity` reports zero valid identities even with
  a correctly imported certificate — then runs `flutter build ipa
  --release` against `ios/ExportOptions.plist` and uploads the signed
  `.ipa` as a workflow artifact.
- `ios/Runner.xcodeproj/project.pbxproj`'s Release configuration was set to
  manual signing (`CODE_SIGN_STYLE`, `DEVELOPMENT_TEAM`,
  `CODE_SIGN_IDENTITY`, `PROVISIONING_PROFILE_SPECIFIER`): the
  `ExportOptions.plist` alone only controls the export step, not the
  earlier `xcodebuild archive` step, which reads signing configuration
  from the Xcode project itself and was still on the `flutter create`
  default of Automatic signing with no team.
- Workflow run `30959271320` completed successfully on 2026-08-04 (5m9s),
  producing the `pass-citizenship-test-ipa` artifact — confirmed via
  `gh run view`.
- Automated TestFlight upload was added to `ios-release.yml`: an App Store
  Connect API key (key ID, issuer ID, and the `.p8` key itself,
  base64-encoded) was generated via the Apple Developer web portal and
  stored as three further repository secrets, and a final workflow step
  decodes the key and runs `xcrun altool --upload-app` against the built
  `.ipa`.
- Three issues were found and fixed before the upload succeeded: (1) the
  `APP_STORE_CONNECT_KEY_BASE64` secret was corrupted after two rounds of
  manual copy-paste (decoding to 186 bytes of garbled binary instead of
  the correct 257-byte PEM key) — fixed by writing the secret directly
  from the local base64 file via `gh secret set` instead of a third manual
  paste, and confirmed by a non-sensitive diagnostic step that prints the
  decoded file's size and first line without ever printing key material;
  (2) altool initially failed with "Cannot determine the Apple ID from
  Bundle ID" (error 19) because an App ID registered in the Developer
  Portal is not the same as an app record in App Store Connect — fixed by
  creating the app listing in App Store Connect for
  `com.hashamahmad.passCitizenshipTest`; (3) altool then rejected the
  upload with "Invalid large app icon" (error 90717) because the
  1024x1024 App Store icon had an alpha channel — fixed by flattening all
  15 icons in `AppIcon.appiconset` to opaque RGB.
- Workflow run `31046642373` completed successfully on 2026-08-05,
  uploading the signed build to TestFlight end-to-end — confirmed via
  `gh run list`.
- Build 1 required an export compliance declaration in App Store Connect
  before it was testable ("None of the algorithms mentioned above" — the
  app is fully offline with no custom or standard encryption of its own;
  `url_launcher` only opens the system browser for external links). The
  owner installed the build via the TestFlight app on a physical iPhone
  on 2026-08-06 and confirmed: Home rendered correctly with real bundled
  data, Practice showed the full production question bank (matching the
  421-question Android result), answering a question showed the correct
  theme-aware feedback panel with explanation and source citation, and no
  crashes occurred during the flow.
- The iOS deployment target was raised from 13.0 to 15.0
  (`ios/Runner.xcodeproj/project.pbxproj`) after Apple's post-upload
  notice ITMS-90068 flagged that MinimumOSVersion below 15.0 will be
  rejected starting Spring 2027. The app was also restricted to
  iPhone-only (`TARGETED_DEVICE_FAMILY = 1`, was the `flutter create`
  default of universal iPhone+iPad) since iPad was never part of this
  release's scope, avoiding an iPad screenshot/QA requirement. Bumping
  the build number from 1.0.0+1 to 1.0.0+2 was also required: Apple
  rejects a re-upload with the same build number as a prior upload
  (`ENTITY_ERROR.ATTRIBUTE.INVALID.DUPLICATE`).
- Six store screenshots were curated from real device captures (Home,
  practice-session category picker, a mock exam in progress, answer
  review with explanation and source citation, exam results, and
  starred questions), chosen to lead with positive/complete states
  rather than the app's legitimate but less flattering "needs
  attention"/low-readiness screens. Processed into `store-assets/ios`
  (1284x2778, App Store Connect's 6.5-inch iPhone Display requirement) and
  `store-assets/android` (native resolution, well within Play's
  looser requirements), plus a 1024x500 Play feature graphic and a
  512x512 Play Store icon, both generated from the same 1024x1024
  icon source used for iOS.
- App Store Connect: Pricing set to Free with worldwide availability,
  App Privacy declared as "Data Not Collected", and App Information
  (subtitle, category) filled in.
- Google Play Console: a new "Pass Citizenship Test" app
  (`com.hashamahmad.pass_citizenship_test`) was registered under a new
  Play Console developer account. Content rating (All Other App
  Types, no ratings-relevant content), target audience (18 and over
  only — the real citizenship test only applies to adult applicants,
  and including under-18 age groups would have pulled the app into
  Play's stricter Families Policy for no reason), privacy policy URL,
  category (Education), and the full store listing (descriptions,
  screenshots, icon, feature graphic) were completed. A fresh signed
  `app-release.aab` (version 1.0.0+2) was built and uploaded to the
  Internal testing track, and the Play-signed/re-delivered build (a
  different artifact from the `adb`-sideloaded APK, since Play App
  Signing re-signs uploads with a Google-managed key) was installed
  and smoke-tested successfully by the owner on 2026-08-08 — the first
  time this app was installed via Google Play's own distribution
  pipeline rather than a direct build.

Notes:

- Passwords in `android/key.properties` were entered by the owner directly
  into that gitignored file and were never shared in chat.
- Building a release variant requires a real `flutter pub get` pass, not
  `--no-pub`: `--no-pub` skips the release-mode plugin-registrant
  regeneration that excludes dev-only packages (e.g. `integration_test`)
  from the generated Android registrant, which otherwise leaves a stale,
  debug-mode registrant that references classes excluded from the release
  dependency graph and fails `compileReleaseJavaWithJavac`. This is a
  genuine Flutter tooling interaction (release-mode dev-dependency
  filtering only runs during `pub get`), not a project misconfiguration;
  worth remembering for any future release build, including in CI.
- The owner does not have a Mac; the entire iOS signing setup (CSR,
  certificate, provisioning profile, and build) was completed without one,
  using the Apple Developer web portal plus a GitHub Actions
  `macos-latest` runner for the actual build.
- `.p12`/provisioning-profile secrets were base64-encoded locally and
  pasted directly into GitHub repository secrets by the owner; the p12
  export password and CI keychain password were never shared in chat.
- Four CI fixes were required across the build-and-upload pipeline and are
  worth remembering for any future signing or release-automation changes:
  (1) a custom CI keychain needs Apple's WWDR intermediate certificates
  imported explicitly, or `security find-identity` reports no valid
  identities even with a correct certificate; (2) `ExportOptions.plist`
  only configures the export step — the Xcode project's own Release build
  settings must be switched to manual signing for the archive step to
  succeed; (3) a GitHub secret can silently end up corrupted after manual
  copy-paste with no error until altool fails at upload time — prefer
  writing secrets from a local file via `gh secret set` over pasting into
  the web UI, and a size/first-line diagnostic (safe to log, never prints
  key material) catches this immediately; (4) registering an App ID in
  the Apple Developer Portal is not sufficient for `altool`/TestFlight —
  an app record with the same bundle ID must also be created in App Store
  Connect first, or the upload fails with "Cannot determine the Apple ID
  from Bundle ID".
- App Store icons must be fully opaque: a 1024x1024 App Store icon (and by
  extension the whole `AppIcon.appiconset`) can't have an alpha channel or
  transparency, even though iOS itself renders app icons fine with one.
  Icon-generation tools that pre-bake rounded corners with a transparent
  margin will fail App Store Connect validation — iOS applies its own
  corner-rounding mask at render time, so the source images should be
  plain opaque squares.

### RR-08 — Complete release documentation, beta testing, and submission

**Status:** `PARTIAL`

**Priority:** `P0`

**Depends on:** RR-07.

**Completion:** 2026-08-18. All substantive work is done — release
notes, privacy/support/beta-testing (byproducts of RR-07's
store-listing work), and both store submissions, which are now
**live**: Android since 2026-08-13, iOS since 2026-08-18. Only
archiving this backlog remains.

- [x] Create release notes for version 1.0.0. See `CHANGELOG.md`.
- [x] Finalize the privacy policy and store privacy declarations.
      `PRIVACY.md` is complete; App Store Connect's App Privacy and Google
      Play's Data Safety form both declare no data collection, matching it.
- [x] Record and implement the Terms of Service decision: no separate Terms of
      Service for the MVP; retain the privacy policy and disclaimer.
- [x] Publish a support contact. Both store listings use the project's
      public GitHub issues page as the support URL.
- [ ] Prepare an optional user guide if required.
- [x] Run Google Play internal testing. `app-release.aab` (1.0.0+2)
      uploaded and smoke-tested successfully on 2026-08-08 (see RR-07
      evidence).
- [x] Run Apple TestFlight testing. Uploaded via GitHub Actions and
      smoke-tested on a physical iPhone on 2026-08-06 (see RR-07 evidence).
- [x] Collect, triage, and record beta feedback. As a solo developer, the
      owner's own physical-device smoke tests on both Internal testing
      (Android) and TestFlight (iOS) served as the beta feedback loop for
      this MVP; no defects were found.
- [x] Resolve every release-blocking beta defect. None found.
- [x] Submit Android and iOS releases. iOS submitted to App Review on
      2026-08-09 (build 3, iPhone-only). Android submitted to Google
      Play's Production track the same day (`app-release.aab` 1.0.0+2,
      reused from the already-tested Internal testing release).
- [x] Respond to store-review feedback. Android approved and live on
      Google Play as of 2026-08-13, no review feedback required.
      iOS's first submission (build 3) hit Guideline 2.1 — Apple
      requested a screen recording plus written detail on device/OS
      testing, app function, external services, regional behavior, and
      the source material's licensing; all provided via App Review
      Information's Notes and Attachment fields, then resubmitted.
      Approved on 2026-08-18 and released by the owner the same day.
- [ ] Archive the completed release-readiness backlog and acceptance evidence.

Acceptance criteria:

- Release documentation matches version 1.0.0 behavior.
- Both beta programs complete with no open critical defects.
- Store submissions contain approved binaries, metadata, screenshots, privacy
  declarations, and support details.
- All retained RR packages are `DONE` with completion dates and evidence.

Evidence:

- The initial "Add for Review" attempt on the 1.0 version page (build 2)
  was blocked by App Store Connect requiring: a 13-inch iPad screenshot
  (because build 2 predates the iPhone-only fix and was still a
  universal iPhone+iPad binary), Content Rights information, a Privacy
  Policy URL specifically within the App Privacy section, the Age
  Rating questionnaire, and publishing the App Privacy declaration
  (it had been filled in but never clicked through Apple's final
  "Publish" confirmation). All five were resolved: build 3
  (iPhone-only, built after bumping to 1.0.0+3) replaced build 2,
  removing the iPad requirement; the remaining four were form/portal
  completions.
- iOS submitted for App Review on 2026-08-09 with build 3 attached,
  version 1.0.0 — confirmed via the "Build" section on the version
  page showing build 3. App Store Connect status changed to "1.0
  Waiting for Review."
- Android's Production release form surfaced a real issue before
  submission: Play Console's "Publishing overview" listed a pending
  change of "Target age is 13 - 15" under Target audience and content,
  contradicting the owner's earlier 18-and-over-only decision (made to
  avoid Play's Families Policy, which this app was never built or
  reviewed against). Caught and corrected to 18+ only before the
  release was sent for review — confirmed by the owner directly in
  App content → Target audience and content.
- Android submitted to Google Play's Production track on 2026-08-09,
  reusing the already Internal-testing-verified `app-release.aab`
  (1.0.0+2) via "Add from library" rather than a fresh upload. No
  closed-testing prerequisite applied to this account — Play Console
  offered "Create new release" directly. Confirmed via the Publishing
  overview checklist showing "Send the release to Google for review"
  complete, with only the automatic post-approval publish step
  remaining.
- **Android is live on Google Play** as of 2026-08-13 — approved by
  Google roughly 4 days after submission (within the expected 7-14 day
  window for a first app on a new developer account, on the faster
  end). Confirmed via the Play Console dashboard: "Latest production
  release ... 100% ... 39 hours ago" and "App update published. Users
  should see changes immediately." No review feedback or changes were
  required — approved as submitted.
- iOS's build 3 submission (2026-08-09) received an App Review message
  the following day: "Guideline 2.1 - Information Needed - New App
  Submission," a standard first-app request rather than a functional
  rejection. Apple asked for a screen recording of core functionality
  plus written answers on: devices/OS tested, app function and target
  audience, setup/credentials, external services used, regional
  behavior, and authorization for any regulated/third-party content.
  Resolved by recording a walkthrough on a physical iPhone 16 Pro Max
  (iOS 26.6) and adding it as an Attachment, and expanding the App
  Review Information Notes field to answer every point — including
  disclosing that question content derives from the Australian
  Government's "Our Common Bond" resource under a CC BY 4.0 licence,
  with in-app attribution. Resubmitted via "Resubmit to App Review."
- **iOS approved for distribution on 2026-08-18.** Set to manual
  release (an owner decision made during the original submission, to
  keep control over exact release timing rather than auto-publishing
  the moment Apple approved). Released by the owner the same day via
  "Release This Version."
- **Both platforms are now live**: Android on Google Play since
  2026-08-13, iOS on the App Store since 2026-08-18.

## MVP release completion gate

Version 1.0.0 is release-ready only when:

- All retained RR packages are `DONE`.
- All eight Android physical-device findings are fixed and re-verified.
- The final question bank contains at least 400 approved questions.
- Static analysis, unit/widget tests, and device integration tests pass.
- Android and iOS physical-device and accessibility audits pass.
- Signed Android and iOS release candidates pass smoke and beta testing.
- Privacy, support, store metadata, screenshots, and release notes are ready.
- No P0 defect or unresolved release-blocking product decision remains.
- Final documentation and archived evidence match the released behavior.

## Recently completed

- [x] Core offline practice, starred questions, timed and untimed exams,
      progress analytics, readiness scoring, settings, and session recovery.
      Status: `DONE`. Completed before 2026-07-30.
- [x] Configuration-driven exam composition with exactly five Australian
      values questions and dual pass criteria.
      Status: `DONE`. Completed before 2026-07-30.
- [x] Optional external Buy Me a Coffee support link without feature gating.
      Status: `DONE`. Completed before 2026-07-30.
- [x] Original implementation backlog audit and archive.
      Status: `DONE`. Completed: 2026-07-30. See
      [`BACKLOG_ARCHIVE_2026-07-30.md`](BACKLOG_ARCHIVE_2026-07-30.md).
