import 'package:dartness_server/src/configuration/schedule/time_unit.dart';

/// Represents an annotation for scheduling tasks with various parameters.
class Scheduled {
  /// A cron-like expression defining the triggers for the scheduled method.
  final String? cron;

  /// The fixed delay between the end of the last invocation and the start of the next.
  final int? fixedDelay;

  /// The fixed delay between the end of the last invocation and the start of the next, parsed from a string.
  final String? fixedDelayString;

  /// The fixed rate of execution, specifying the period between invocations.
  final int? fixedRate;

  /// The fixed rate of execution, parsed from a string.
  final String? fixedRateString;

  /// The number of units of time to delay before the first execution of a fixed-rate or fixed-delay task.
  final int? initialDelay;

  /// The number of units of time to delay before the first execution, parsed from a string.
  final String? initialDelayString;

  /// A qualifier for determining a scheduler to run this scheduled method on.
  final String? scheduler;

  /// The time unit to use for fixedDelay, fixedDelayString, fixedRate, fixedRateString, initialDelay, and initialDelayString.
  final TimeUnit? timeUnit;

  /// A time zone for which the cron expression will be resolved.
  final String? zone;

  /// Constructor for the Scheduled annotation.
  const Scheduled({
    this.cron,
    this.fixedDelay,
    this.fixedDelayString,
    this.fixedRate,
    this.fixedRateString,
    this.initialDelay,
    this.initialDelayString,
    this.scheduler,
    this.timeUnit,
    this.zone,
  });
}
