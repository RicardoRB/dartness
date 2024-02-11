import 'package:dartness_server/schedule.dart';
import 'package:test/test.dart';

void main() {
  group('CronExpression Parsing', () {
    test('parses wildcard expressions correctly', () {
      final expression = CronExpression.parse('* * * * * *');
      expect(expression.seconds, equals(['*']));
      expect(expression.minutes, equals(['*']));
      expect(expression.hours, equals(['*']));
      expect(expression.days, equals(['*']));
      expect(expression.months, equals(['*']));
      expect(expression.weekdays, equals(['*']));
    });

    test('parses specific value expressions correctly', () {
      final expression = CronExpression.parse('5 30 2 15 6 3');
      expect(expression.seconds, equals(['5']));
      expect(expression.minutes, equals(['30']));
      expect(expression.hours, equals(['2']));
      expect(expression.days, equals(['15']));
      expect(expression.months, equals(['6']));
      expect(expression.weekdays, equals(['3']));
    });

    test('parses list expressions correctly', () {
      final expression = CronExpression.parse('1,5 10,20,30 * * * *');
      expect(expression.seconds, equals(['1', '5']));
      expect(expression.minutes, equals(['10', '20', '30']));
      expect(expression.hours, contains('*'));
    });

    test('parses range expressions correctly', () {
      final expression = CronExpression.parse('1-5 10-12 * * * *');
      expect(expression.seconds, equals(['1-5']));
      expect(expression.minutes, equals(['10-12']));
    });

    test('parses step values correctly', () {
      final expression = CronExpression.parse('*/5 */10 * * * *');
      expect(expression.seconds, equals(['*/5']));
      expect(expression.minutes, equals(['*/10']));
    });

    test('throws FormatException for invalid cron string length', () {
      expect(() => CronExpression.parse('5 4 3 2'),
          throwsA(isA<FormatException>()));
    });

    test('throws FormatException for out-of-range values', () {
      // Assuming seconds are 0-59, minutes are 0-59, and so on.
      // This example checks for an out-of-range minute value.
      expect(() => CronExpression.parse('0 60 * * * *'),
          throwsA(isA<FormatException>()));
    });

    test('throws FormatException for invalid characters', () {
      // This test assumes the parser does not support special characters or letters
      expect(() => CronExpression.parse('* * * * * L'),
          throwsA(isA<FormatException>()));
    });

    test('throws FormatException for invalid range', () {
      // Example: Start of range is greater than end
      expect(() => CronExpression.parse('30-5 * * * * *'),
          throwsA(isA<FormatException>()));
    });

    test('throws FormatException for unsupported step values', () {
      // Example: Step value is used where not supported or is malformed
      expect(() => CronExpression.parse('*/60 * * * * *'),
          throwsA(isA<FormatException>()));
    });
  });
}
