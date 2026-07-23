import 'dart:convert';
import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

abstract final class AppLogger {
  static void debug(String message, {Map<String, Object?> fields = const {}}) {
    _write(LogLevel.debug, message, fields: fields);
  }

  static void info(String message, {Map<String, Object?> fields = const {}}) {
    _write(LogLevel.info, message, fields: fields);
  }

  static void warning(
    String message, {
    Map<String, Object?> fields = const {},
  }) {
    _write(LogLevel.warning, message, fields: fields);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> fields = const {},
  }) {
    _write(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      fields: fields,
    );
  }

  static void _write(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> fields = const {},
  }) {
    final suffix = fields.isEmpty ? '' : ' ${jsonEncode(fields)}';
    developer.log(
      '$message$suffix',
      name: 'citizenship_test.${level.name}',
      level: switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      },
      error: error,
      stackTrace: stackTrace,
    );
  }
}
