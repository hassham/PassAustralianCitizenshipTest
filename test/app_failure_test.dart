import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/core/errors/app_failure.dart';
import 'package:pass_citizenship_test/features/practice/data/question_bank_validator.dart';

void main() {
  test('maps invalid question content to a recoverable content failure', () {
    final failure = AppFailure.from(
      QuestionBankValidationException(['questions[0] is invalid']),
    );

    expect(failure, isA<ContentFailure>());
    expect(failure.canRetry, isTrue);
  });

  test('maps database errors to a recoverable storage failure', () {
    final failure = AppFailure.from(_FakeDatabaseException());

    expect(failure, isA<StorageFailure>());
    expect(failure.canRetry, isTrue);
  });
}

class _FakeDatabaseException implements Exception {}
