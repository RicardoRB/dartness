import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartness_server/dartness.dart';
import 'package:source_gen/source_gen.dart';

class ApplicationGenerator extends GeneratorForAnnotation<Application> {
  static final _applicationType = TypeChecker.fromRuntime(Application);

  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is ClassElement) {
      final buffer = StringBuffer();
      buffer.writeln('extension ${element.name}Extension on ${element.name} {');
      buffer.writeln('initDependencies(){');

      buffer.writeln('final injectRegister = InstanceRegister.instance;');
      final applicationModule = annotation.read('module').objectValue;
      final moduleMetadata = applicationModule.getField('metadata');
      final controllers =
          moduleMetadata?.getField('controllers')?.toListValue() ?? [];
      final providers =
          moduleMetadata?.getField('providers')?.toListValue() ?? [];
      final List<DartObject> allInstances = [];
      allInstances.addAll(controllers);
      allInstances.addAll(providers);
      final classElementControllers = allInstances
          .map((e) => e.toTypeValue()?.element)
          .whereType<ClassElement>()
          .toList();

      final topologicalControllers = _topologicalSort(classElementControllers);

      for (final controllerElement in topologicalControllers) {
        final constructors = controllerElement.constructors;

        if (constructors.length > 1) {
          throw Exception(
              '${controllerElement.name} has more than 1 constructor.'
              '@$_applicationType do not allow multiple constructors currently');
        }

        final constructor = constructors.first;
        if (constructor.isPrivate) {
          throw Exception('${controllerElement.name}\' constructor is private.'
              'A public constructor is required in order '
              'to create an instance of the class');
        }

        buffer.writeln('injectRegister.register<${controllerElement.name}>(');
        buffer.writeln('${controllerElement.name}(');

        for (final constructorParam in constructor.parameters) {
          buffer.writeln('injectRegister.resolve<${constructorParam.type}>(),');
        }

        buffer.writeln('));');
      }

      // initDependencies method end
      buffer.writeln('}');
      // class end
      buffer.writeln('}');
      return buffer.toString();
    }

    return null;
  }

  List<ClassElement> _topologicalSort(List<ClassElement> dependencies) {
    final visited = <ClassElement>{};
    final sorted = <ClassElement>[];

    void visit(ClassElement dependency) {
      if (visited.contains(dependency)) return;
      visited.add(dependency);

      final dependencies = _getDependencies(dependency);

      for (final dep in dependencies) {
        visit(dep);
      }

      sorted.add(dependency);
    }

    for (final dependency in dependencies) {
      visit(dependency);
    }

    sorted.reversed.toList();
    return sorted;
  }

  List<ClassElement> _getDependencies(ClassElement dependency) {
    final dependencies = <ClassElement>[];

    final constructor = dependency.unnamedConstructor;
    if (constructor != null) {
      final parameters = constructor.parameters;
      for (final param in parameters) {
        final paramElement = param.type.element;
        if (paramElement is ClassElement) {
          dependencies.add(paramElement);
        }
      }
    }

    return dependencies;
  }
}
