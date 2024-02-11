import 'package:dartness_server/schedule.dart';
import 'package:dartness_server/src/configuration/schedule/time_provider.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

// Mock implementation of TimeProvider for testing purposes.
class MockTimeProvider implements TimeProvider {
  // The mock time to be returned by now().
  DateTime fakeTime;

  MockTimeProvider(this.fakeTime);

  @override
  DateTime now() => fakeTime;

  // Allows tests to simulate the passage of time by advancing the fakeTime.
  void advanceTime(Duration duration) {
    fakeTime = fakeTime.add(duration);
  }
}

void main() {
  group('CronScheduler', () {
    test('starts and stops without errors', () async {
      // Arrange
      // Every second
      var cronExpression = CronExpression.parse('* * * * * *');
      var scheduler = CronScheduler(cronExpression);
      var taskExecuted = false;

      // Act
      scheduler.start(() => taskExecuted = true);
      // Wait for at least one cycle
      await Future.delayed(Duration(seconds: 2));
      scheduler.stop();

      // Assert
      expect(taskExecuted, isTrue);
    });

    test('executes task every second', () async {
      // Arrange
      var cronExpression = CronExpression.parse('* * * * * *'); // Every second
      var scheduler = CronScheduler(cronExpression);
      var executionCount = 0;
      void task() => executionCount++;

      // Act
      // Wait to accumulate executions
      scheduler.start(task);
      await Future.delayed(Duration(
        seconds: 5,
      ));
      scheduler.stop();

      // Assert
      // Accounting for potential timing issues
      expect(executionCount, greaterThanOrEqualTo(4));
    });

    test('does not execute task after being stopped', () async {
      // Arrange
      var cronExpression = CronExpression.parse('* * * * * *'); // Every second
      var scheduler = CronScheduler(cronExpression);
      var executionCount = 0;
      void task() => executionCount++;

      // Act
      scheduler.start(task);
      // Allow some executions
      await Future.delayed(Duration(seconds: 2));
      scheduler.stop();
      var countAfterStop = executionCount;
      // Wait to see if it stops executing
      await Future.delayed(Duration(
        seconds: 2,
      ));

      // Assert
      expect(executionCount, countAfterStop);
    });
  });

  group('CronScheduler with Mock Time', () {
    test('executes task when time matches', () {
      fakeAsync((async) {
        // Arrange
        var mockTime = DateTime(2020, 1, 1, 12, 0);
        var mockTimeProvider = MockTimeProvider(mockTime);
        var cronExpression = CronExpression.parse('* * * * * *');
        var scheduler = CronScheduler(
          cronExpression,
          timeProvider: mockTimeProvider,
        );
        var executionCount = 0;

        scheduler.start(() => executionCount++);

        // Act: Simulate 2 seconds passing
        async.elapse(Duration(seconds: 2));

        // Assert: Task should have executed at least once
        expect(executionCount, greaterThanOrEqualTo(1));

        // Cleanup
        scheduler.stop();
      });
    });
  });
}
