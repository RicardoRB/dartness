// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_scheduler.dart';

// **************************************************************************
// SchedulerGenerator
// **************************************************************************

extension ExampleSchedulerExtension on ExampleScheduler {
  void initSchedules() {
    final scheduler0 = SchedulerManager("* * * * *");
    scheduler0.start(example);
  }
}
