/// A class representing a cron expression, used for scheduling tasks.
class CronExpression {
  final List<String> seconds;
  final List<String> minutes;
  final List<String> hours;
  final List<String> days;
  final List<String> months;
  final List<String> weekdays;

  CronExpression({
    required this.seconds,
    required this.minutes,
    required this.hours,
    required this.days,
    required this.months,
    required this.weekdays,
  });

  /// Parses a cron string into its components.
  ///
  /// The cron string must have 6 parts, separated by spaces, representing:
  /// seconds, minutes, hours, day of month, month, and day of week.
  factory CronExpression.parse(String cronString) {
    final parts = cronString.split(' ');
    if (parts.length != 6) {
      throw FormatException('Invalid cron string length');
    }

    // Validate and parse each field
    return CronExpression(
      seconds: _parseField(parts[0], 0, 59),
      minutes: _parseField(parts[1], 0, 59),
      hours: _parseField(parts[2], 0, 23),
      days: _parseField(parts[3], 1, 31),
      months: _parseField(parts[4], 1, 12),
      weekdays: _parseField(parts[5], 0, 7),
    );
  }

  static List<String> _parseField(String field, int min, int max) {
    // Wildcard
    if (field == '*') {
      return [field];
    }

    // Step values
    if (field.contains('/')) {
      final stepParts = field.split('/');
      if (stepParts[0] != '*' &&
          !stepParts[0].contains('-') &&
          int.tryParse(stepParts[1]) == null) {
        throw FormatException('Unsupported or malformed step value');
      }
      if (stepParts[0] == '*' && int.parse(stepParts[1]) > max) {
        throw FormatException('Step value out of range');
      }
      return [field];
    }

    // Range values
    if (field.contains('-')) {
      final rangeParts = field.split('-').map(int.parse).toList();
      if (rangeParts[0] > rangeParts[1]) {
        throw FormatException('Invalid range');
      }
      if (rangeParts.any((val) => val < min || val > max)) {
        throw FormatException('Range value out of bounds');
      }
      return [field];
    }

    // List values
    final listParts = field.split(',');
    for (var part in listParts) {
      final value = int.tryParse(part);
      if (value == null || value < min || value > max) {
        throw FormatException('Value out of bounds');
      }
    }
    return listParts;
  }

  @override
  String toString() {
    return 'CronExpression(seconds: $seconds, minutes: $minutes, hours: $hours, days: $days, months: $months, weekdays: $weekdays)';
  }
}
