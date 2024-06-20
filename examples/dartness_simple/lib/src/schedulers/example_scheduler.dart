import 'package:dartness_server/schedule.dart';

part 'example_scheduler.g.dart';

@Scheduler()
class ExampleScheduler {
  @Scheduled(cron: "* * * * *")
  void example() {
    print("${DateTime.now()} Hello world");
  }
}
