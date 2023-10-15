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

      _createInitDependencies(buffer, annotation);

      _createMain(buffer, annotation);

      // class end
      buffer.writeln('}');
      return buffer.toString();
    }

    return null;
  }

  void _createInitDependencies(
    final StringBuffer buffer,
    final ConstantReader annotation,
  ) {
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
    final allProviderElements = allInstances
        .map((e) => e.getField('classType'))
        .map((e) => e?.toTypeValue()?.element)
        .whereType<ClassElement>()
        .toList();

    final topologicalProviderElements = _topologicalSort(allProviderElements);

    for (final providerElement in topologicalProviderElements) {
      final constructors = providerElement.constructors;

      if (constructors.length > 1) {
        throw Exception('${providerElement.name} has more than 1 constructor.'
            '@$_applicationType do not allow multiple constructors currently');
      }

      final constructor = constructors.first;
      if (constructor.isPrivate) {
        throw Exception('${providerElement.name}\' constructor is private.'
            'A public constructor is required in order '
            'to create an instance of the class');
      }

      buffer.writeln('injectRegister.register<${providerElement.name}>(');
      buffer.writeln('${providerElement.name}(');

      for (final constructorParam in constructor.parameters) {
        buffer.writeln(
            'injectRegister.resolve<${constructorParam.type.getDisplayString(
          withNullability: false,
        )}>(),');
      }

      buffer.writeln('));');
    }

    // initDependencies method end
    buffer.writeln('}');
  }

  List<ClassElement> _topologicalSort(final List<ClassElement> dependencies) {
    final visited = <ClassElement>{};
    final sorted = <ClassElement>[];

    for (final dependency in dependencies) {
      _visit(dependency, visited, sorted);
    }

    return sorted.toList();
  }

  void _visit(final ClassElement dependency, final Set<ClassElement> visited,
      final List<ClassElement> sorted) {
    if (visited.contains(dependency)) {
      return;
    }

    visited.add(dependency);

    final dependencies = _getDependencies(dependency);

    for (final dep in dependencies) {
      _visit(dep, visited, sorted);
    }

    sorted.add(dependency);
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

  void _createMain(StringBuffer buffer, ConstantReader annotation) {
    buffer.writeln('Future<void> main() async {');

    buffer.writeln('initDependencies();');
    buffer.writeln('final injectRegister = InstanceRegister.instance;');
    buffer.writeln('final app = Dartness();');

    final applicationModule = annotation.read('module').objectValue;
    final moduleMetadata = applicationModule.getField('metadata');
    final controllers =
        moduleMetadata?.getField('controllers')?.toListValue() ?? [];

    final controllerElements = controllers
        .map((e) => e.getField('classType'))
        .map((e) => e?.toTypeValue()?.element)
        .whereType<ClassElement>()
        .toList();
    final applicationOptions = annotation.read('options').objectValue;

    if (applicationOptions.isNull) {
      buffer.writeln('await app.create(');
      _generateControllers(controllerElements, buffer);
      buffer.writeln(');');
    } else {
      final logRequest =
          applicationOptions.getField('logRequest')?.toBoolValue();
      final port = applicationOptions.getField('port')?.toIntValue();
      final internetAddress =
          applicationOptions.getField('internetAddress')?.toTypeValue();
      buffer.writeln('await app.create(');
      _generateControllers(controllerElements, buffer);
      buffer.writeln('options: DartnessApplicationOptions(');
      if (logRequest != null) {
        buffer.writeln('logRequest: $logRequest,');
      }
      if (port != null) {
        buffer.writeln('port: $port,');
      }
      if (internetAddress != null) {
        buffer.writeln('internetAddress: $internetAddress,');
      }
      buffer.writeln('),');
      buffer.writeln(');');
    }

    // main end method
    buffer.writeln('}');
  }

  void _generateControllers(
    final List<ClassElement> controllerElements,
    final StringBuffer buffer,
  ) {
    buffer.writeln('controllers: [');
    for (final controllerElement in controllerElements) {
      final className = controllerElement.name.contains('Controller')
          ? controllerElement.name
              .replaceAll('Controller', 'DartnessController')
          : '${controllerElement.name}DartnessController';

      buffer.writeln(
          '$className(injectRegister.resolve<${controllerElement.name}>()),');
    }

    buffer.writeln('],');
  }
}
