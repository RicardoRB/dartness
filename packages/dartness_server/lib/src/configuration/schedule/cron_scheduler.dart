import 'dart:async';

import 'cron_expression.dart';
import 'system_time_provider.dart';
import 'time_provider.dart';

/// Scheduler class that uses a [CronExpression] to execute tasks periodically.
class CronScheduler {
  final CronExpression cronExpression;
  // TimeProvider allows for injecting a custom time source, facilitating testing.
  final TimeProvider timeProvider;
  Timer? _timer;

  // Constructor accepts a cron expression and an optional custom TimeProvider.
  // If no TimeProvider is provided, it defaults to the system clock.
  CronScheduler(this.cronExpression, {TimeProvider? timeProvider})
      : timeProvider = timeProvider ?? SystemTimeProvider();

  /// Starts the periodic execution of a task based on the cron expression.
  /// [task] is a function with no parameters that encapsulates
  /// the invocation of the actual task function with its parameters.
  void start(void Function() task) {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      var now = timeProvider.now();
      // Checks if the current time matches the cron expression before executing the task.
      if (_matches(now)) {
        task();
      }
    });
  }

  /// Checks if the current time matches the cron expression.
  bool _matches(final DateTime dateTime) {
    return (cronExpression.seconds.contains('*') ||
            cronExpression.seconds.contains(dateTime.second.toString())) &&
        (cronExpression.minutes.contains('*') ||
            cronExpression.minutes.contains(dateTime.minute.toString())) &&
        (cronExpression.hours.contains('*') ||
            cronExpression.hours.contains(dateTime.hour.toString())) &&
        (cronExpression.days.contains('*') ||
            cronExpression.days.contains(dateTime.day.toString())) &&
        (cronExpression.months.contains('*') ||
            cronExpression.months.contains(dateTime.month.toString())) &&
        (cronExpression.weekdays.contains('*') ||
            cronExpression.weekdays.contains(dateTime.weekday.toString()));
  }

  /// Stops the periodic execution of the task.
  void stop() {
    _timer?.cancel();
  }
}
