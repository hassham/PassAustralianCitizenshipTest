import '../../features/practice/data/question_bank_validator.dart';
import '../services/app_logger.dart';

sealed class AppFailure implements Exception {
  const AppFailure({
    required this.title,
    required this.message,
    required this.canRetry,
    this.cause,
  });

  final String title;
  final String message;
  final bool canRetry;
  final Object? cause;

  static AppFailure from(Object error) {
    if (error is AppFailure) return error;
    AppLogger.error('Operation failed', error: error);
    if (error is QuestionBankValidationException || error is FormatException) {
      return ContentFailure(cause: error);
    }
    final description = error.toString().toLowerCase();
    if (description.contains('unable to load asset') ||
        description.contains('question bank')) {
      return ContentFailure(cause: error);
    }
    final type = error.runtimeType.toString().toLowerCase();
    if (type.contains('sqlite') ||
        type.contains('drift') ||
        type.contains('database')) {
      return StorageFailure(cause: error);
    }
    return UnexpectedFailure(cause: error);
  }

  @override
  String toString() => message;
}

final class ContentFailure extends AppFailure {
  const ContentFailure({
    super.cause,
    super.message =
        'The question bank could not be loaded. Retry the import, and '
        'reinstall the app if the problem continues.',
  }) : super(title: 'Study content is unavailable', canRetry: true);
}

final class StorageFailure extends AppFailure {
  const StorageFailure({super.cause})
    : super(
        title: 'Saved data could not be opened',
        message:
            'The app could not access its local database. Restart the app and '
            'try again.',
        canRetry: true,
      );
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({super.cause})
    : super(
        title: 'Something went wrong',
        message: 'The operation could not be completed. Please try again.',
        canRetry: true,
      );
}
