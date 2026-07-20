# Pass Australian Citizenship Test

An offline-first Flutter study app for the Australian Citizenship Test.

## Current milestone

The first working vertical slice supports:

- practice across all questions or a selected category
- immediate answer feedback and explanations
- locally persisted attempts and progress
- restoration of an unfinished practice session after restart
- bundled, development-only sample content

The sample questions are placeholders for implementation testing and require an accuracy and copyright review before release.

## Run locally

```text
flutter pub get
dart run build_runner build
flutter run
```

An Android SDK is required for Android builds. Run `flutter doctor` after installing the platform toolchain.

## Quality checks

```text
flutter analyze
flutter test
```

See `docs/` for the product and technical specifications and `BACKLOG.md` for implementation status.
