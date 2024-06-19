import 'package:dartness_server/src/configuration/schedule/time_unit.dart';

/// Represents an annotation for scheduling tasks with various parameters.
class Scheduled {
  /// A cron-like expression defining the triggers for the scheduled method.
  final String? cron;

  /// Constructor for the Scheduled annotation.
  const Scheduled({
    this.cron,
  });
}
