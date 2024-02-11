import 'time_provider.dart';

// Default implementation of TimeProvider using the system clock.
class SystemTimeProvider implements TimeProvider {
  @override
  DateTime now() => DateTime.now();
}
