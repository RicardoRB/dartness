/// Represents an annotation for scheduling task
class Scheduled {
  /// A cron-like expression defining the triggers for the scheduled method.
  final String cron;

  /// Constructor for the Scheduled annotation.
  const Scheduled({
    required this.cron,
  });
}
