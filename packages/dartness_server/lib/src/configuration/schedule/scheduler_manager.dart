import 'package:cron/cron.dart';

/// Scheduler class that uses a [CronExpression] to execute tasks periodically.
class SchedulerManager {
  final String cronExpression;
  final Cron cron;

  // Constructor accepts a cron expression and an optional custom TimeProvider.
  // If no TimeProvider is provided, it defaults to the system clock.
  SchedulerManager(this.cronExpression) : cron = Cron();

  /// Starts the periodic execution of a task based on the cron expression.
  /// [task] is a function with no parameters that encapsulates
  /// the invocation of the actual task function with its parameters.
  void start(void Function() task) {
    cron.schedule(Schedule.parse(cronExpression), task);
  }

  /// Stops the periodic execution of the task.
  void stop() {
    cron.close();
  }
}
