import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartness_server/schedule.dart';
import 'package:source_gen/source_gen.dart';

class SchedulerGenerator extends GeneratorForAnnotation<Scheduler> {
  static final _scheduledType = TypeChecker.fromRuntime(Scheduled);

  @override
  String? generateForAnnotatedElement(
    final Element element,
    final ConstantReader annotation,
    final BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '@${element.name} cannot target `${element.runtimeType}`. '
          'It is not a class.');
    }

    final scheduledList = _findScheduledElements(element);

    final buffer = StringBuffer();
    buffer.writeln('extension ${element.name}Extension on ${element.name} {');
    buffer.writeln('void initSchedules() {');
    int count = 0;
    for (final scheduledExpression in scheduledList) {
      final scheduledAnnotation =
          _scheduledType.firstAnnotationOfExact(scheduledExpression);

      final cron = scheduledAnnotation?.getField('cron')?.toStringValue();
      if (cron != null) {
        buffer.writeln('final scheduler$count = SchedulerManager("$cron");');
        buffer.writeln('scheduler$count.start(${scheduledExpression.name});');
      }
      count++;
    }
    // Ends initSchedules
    buffer.writeln('}');

    // Ends extension
    buffer.writeln('}');
    return buffer.toString();
  }

  List<ExecutableElement> _findScheduledElements(ClassElement classElement) => [
        ...classElement.methods.where(_scheduledType.hasAnnotationOf),
        ...classElement.accessors.where(_scheduledType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
