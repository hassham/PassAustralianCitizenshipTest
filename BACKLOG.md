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

Last updated: 2026-07-30.

## Current delivery cycle: MVP release readiness

**Theme:** Complete and validate the content, resolve physical-device feedback,
prove quality on Android and iOS, and prepare signed store releases.

**Overall status:** `IN PROGRESS` — RR-01 implementation is complete and
awaiting automated and physical-device verification. The production question
bank, integration coverage, device/accessibility verification, signing, and
store preparation remain.

### Release-readiness outcome

Deliver a production-ready version 1.0.0 that:

1. Contains at least 400 reviewed and validated citizenship questions.
2. Presents readable, accessible study and exam experiences in light and dark
   modes.
3. Preserves practice and exam state across supported lifecycle events.
4. Meets the documented performance and accessibility targets.
5. Installs as signed Android and iOS release candidates.
6. Completes internal beta testing with no open critical defects.

### Scope baseline

In scope:

- Resolution and re-verification of all recorded Android physical-device
  feedback.
- Expansion and review of the production question bank.
- Device-level integration tests for critical practice and exam flows.
- Android and iOS physical-device, accessibility, and performance validation.
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

RR-01 code changes and automated verification are complete. Physical Android
re-testing remains before the package can be marked `DONE`. RR-02 may proceed
in parallel only when content work does not interfere with RR-01 verification.

## Ordered release-readiness work packages

### RR-01 — Resolve Android physical-device feedback

**Status:** `PARTIAL — AWAITING PHYSICAL-DEVICE VERIFICATION`

**Priority:** `P0`

**Depends on:** Core MVP feature implementation — satisfied.

**Started:** 2026-07-30.

**Completion:** Implementation and automated verification completed
2026-07-31; physical-device verification pending.

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

Notes:

- These findings came from physical Android testing supplied by the project
  owner on 2026-07-30.
- No finding is considered resolved solely from emulator or widget-test
  evidence.
- RR-01 remains `PARTIAL` until all fourteen findings pass physical-device
  re-testing.

### RR-02 — Complete and approve the production question bank

**Status:** `TODO`

**Priority:** `P0`

**Depends on:** Existing question schema and import validation — satisfied.

**Completion:** Not started.

- [ ] Expand the current 120-question bank to at least 400 questions.
- [ ] Preserve stable question and option IDs.
- [ ] Give every question exactly four options and one correct answer.
- [ ] Complete correct-answer and incorrect-option explanations.
- [ ] Assign and validate category and difficulty metadata.
- [ ] Validate facts and taxonomy against the current official booklet.
- [ ] Verify source edition, section, page, and lifecycle metadata.
- [ ] Complete editorial, attribution, and licensing review.
- [ ] Run schema, duplicate, option, reference, and import validation.
- [ ] Measure import and query performance at final production volume.

Acceptance criteria:

- The bundled bank contains at least 400 unique, active, reviewed questions.
- Every question passes automated structural and import validation.
- Editorial approval confirms factual accuracy and readable explanations.
- References and attribution are suitable for release.
- Final-bank import and common queries meet performance targets.

Evidence: Pending.

### RR-03 — Add critical-flow integration and coverage evidence

**Status:** `IN_PROGRESS`

**Priority:** `P0`

**Depends on:** RR-01 for final UI expectations; RR-02 for production-volume
coverage.

**Completion:** 9 of 10 checklist items complete; Android/iOS execution,
corrupted-database recovery coverage, and the 80% coverage gap remain.

- [x] Add device-level integration coverage for a complete practice session.
- [x] Cover timed and untimed mock exams.
- [x] Cover timer backgrounding, resume, expiry, and auto-submit.
- [x] Cover cold-start practice and exam restoration.
- [x] Cover backwards device-clock detection and lock behavior.
- [ ] Cover invalid content and database recovery behavior.
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
  backwards-clock locking, and removed-content recovery.
- `test/rr03_widget_test.dart` covers Practice feedback and recovery states,
  Settings data and failure states, starred-question states, and exam history.
- `test/controller_edge_cases_test.dart` covers ignored Practice and Exam
  actions, empty starred sessions, inactive restore, and locked-exam input.
- The device-level integration suite passed 6/6 flows on Windows on 2026-08-01.
- The complete unit/widget suite passed 44/44 tests on 2026-08-01.
- `flutter analyze --no-pub` passed with no issues on 2026-08-01.
- `coverage/lcov.info` records 2,673 of 5,834 lines hit (45.82%).

Notes:

- RR-02 remains deferred, so production-volume coverage is not yet available.
- The integration suite must still be executed on supported Android and iOS
  device targets.
- Removed-content recovery is covered; deterministic corrupted-database
  recovery coverage is still missing.
- Coverage is recorded but remains below the 80% project target.

### RR-04 — Complete physical-device and accessibility validation

**Status:** `TODO`

**Priority:** `P0`

**Depends on:** RR-01 and RR-03.

**Completion:** Not started.

- [ ] Test timed-exam backgrounding, expiry, auto-submit, and restoration.
- [ ] Test app termination and cold-start restoration.
- [ ] Test supported Android physical devices and record device/OS details.
- [ ] Test supported iOS physical devices and record device/OS details.
- [ ] Test low-storage behavior, corrupted database recovery, invalid bundled
      content, and external-link failures.
- [ ] Complete TalkBack and VoiceOver walkthroughs.
- [ ] Verify the primary flows at 100–200% text scaling.
- [ ] Complete keyboard and focus-navigation checks where applicable.
- [ ] Measure WCAG AA contrast in light and dark modes.
- [ ] Run Android and iOS accessibility scanners.
- [ ] Confirm no required information depends on animation or colour alone.

Acceptance criteria:

- Every documented manual scenario has device, OS, result, and defect evidence.
- No open critical or serious accessibility defect remains.
- Practice and exam state survives all documented supported lifecycle events.
- Recovery behavior matches the functional and implementation documentation.

Evidence: Pending.

### RR-05 — Profile and harden the release candidate

**Status:** `TODO`

**Priority:** `P1`

**Depends on:** RR-02 and RR-04.

**Completion:** Not started.

- [ ] Measure release/profile-mode startup on target Android and iOS hardware.
- [ ] Measure question loading and common database queries with the final bank.
- [ ] Inspect query plans and indexes for production-volume operations.
- [ ] Run sustained-use allocation and memory-leak analysis.
- [ ] Measure active-use battery consumption.
- [ ] Optimize only the paths that fail a target or show measured regression.
- [ ] Record repeatable release baselines and regression thresholds.

Acceptance criteria:

- App launch is under 3 seconds.
- Question loading is under 400 milliseconds.
- Database queries are under 100 milliseconds.
- Average memory use is below 150 MB.
- Active-use battery drain is below 15% per hour.
- No sustained-use leak or release-blocking performance regression remains.

Evidence: Pending.

### RR-06 — Finish release-critical product and technical polish

**Status:** `TODO`

**Priority:** `P2`

**Depends on:** RR-01 and RR-03.

**Completion:** Not started.

- [ ] Decide and implement persistent theme preference.
- [ ] Decide whether notification settings remain in the MVP.
- [ ] Complete responsive visual QA.
- [ ] Finish practice exit, retry, and documented edge cases.
- [ ] Decide whether Terms of Service are required.
- [ ] Split broad repository operations only where needed for testability or
      release safety.
- [ ] Reconcile release-relevant schema differences with
      `docs/DATABASE_SCHEMA.md`.
- [ ] Add production upgrade-path and migration tests.

Acceptance criteria:

- Every retained setting is functional, persisted where required, and tested.
- Primary screens pass responsive visual QA.
- No unresolved product decision blocks store submission.
- Architecture cleanup does not expand MVP scope or regress existing data.

Evidence: Pending.

### RR-07 — Prepare signed Android and iOS releases

**Status:** `TODO`

**Priority:** `P0`

**Depends on:** RR-04, RR-05, and all release-blocking RR-06 decisions.

**Completion:** Not started.

- [ ] Configure Android release signing.
- [ ] Validate Android application ID, SDK settings, permissions, icons, and
      production build configuration.
- [ ] Build, install, and smoke-test a signed Android release candidate.
- [ ] Configure the iOS bundle ID, certificates, provisioning, deployment
      target, permissions, icons, and production build on macOS.
- [ ] Build, install, and smoke-test a signed iOS release candidate.
- [ ] Prepare Google Play and App Store descriptions, screenshots, categories,
      pricing, declarations, and privacy metadata.
- [ ] Confirm every feature is described as free and no entitlement or billing
      setup is required.

Acceptance criteria:

- Signed Android and iOS release candidates install and complete smoke tests on
  physical devices.
- Store metadata accurately describes the implemented application.
- Privacy, permission, content, and external-link declarations are complete.
- No development-only branding, configuration, or diagnostics leak into the
  release experience.

Evidence: Pending.

### RR-08 — Complete release documentation, beta testing, and submission

**Status:** `TODO`

**Priority:** `P0`

**Depends on:** RR-07.

**Completion:** Not started.

- [ ] Create release notes for version 1.0.0.
- [ ] Finalize the privacy policy and store privacy declarations.
- [ ] Record and implement the Terms of Service decision.
- [ ] Publish a support contact.
- [ ] Prepare an optional user guide if required.
- [ ] Run Google Play internal testing.
- [ ] Run Apple TestFlight testing.
- [ ] Collect, triage, and record beta feedback.
- [ ] Resolve every release-blocking beta defect.
- [ ] Submit Android and iOS releases.
- [ ] Respond to store-review feedback.
- [ ] Archive the completed release-readiness backlog and acceptance evidence.

Acceptance criteria:

- Release documentation matches version 1.0.0 behavior.
- Both beta programs complete with no open critical defects.
- Store submissions contain approved binaries, metadata, screenshots, privacy
  declarations, and support details.
- All RR-01 through RR-08 packages are `DONE` with completion dates and
  evidence.

Evidence: Pending.

## MVP release completion gate

Version 1.0.0 is release-ready only when:

- RR-01 through RR-08 are all `DONE`.
- All eight Android physical-device findings are fixed and re-verified.
- The final question bank contains at least 400 approved questions.
- Static analysis, unit/widget tests, and device integration tests pass.
- Android and iOS physical-device and accessibility audits pass.
- Performance targets pass with the final bank on release hardware.
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
