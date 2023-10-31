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

  /// Creates 'initDependencies' method
  void _createInitDependencies(
    final StringBuffer buffer,
    final ConstantReader annotation,
  ) {
    buffer.writeln('initDependencies(){');

    buffer.writeln('final injectRegister = InstanceRegister.instance;');
    final applicationModule = annotation.read('module').objectValue;
    final moduleMetadata = applicationModule.getField('metadata');
    final List<DartObject> allControllers = _getAllControllers(moduleMetadata);
    final List<DartObject> allProviders = _getAllProviders(moduleMetadata);

    final List<DartObject> allInstances = [];
    allInstances.addAll(allControllers);
    allInstances.addAll(allProviders);
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

      _registerClass(buffer, providerElement);

      final Iterable<DartObject> allClassTypeProviders =
          allInstances.where((element) {
        final instanceElement =
            element.getField('classType')?.toTypeValue()?.element;
        return instanceElement == providerElement;
      }).where((element) => element.getField('name')?.toStringValue() != null);

      if (allClassTypeProviders.isNotEmpty) {
        for (final nameTypeProvider in allClassTypeProviders) {
          final nameField = nameTypeProvider.getField('name');
          _registerClass(
            buffer,
            providerElement,
            name: nameField?.toStringValue(),
          );
        }
      }
    }

    // initDependencies method end
    buffer.writeln('}');
  }

  void _registerClass(
    final StringBuffer buffer,
    final ClassElement providerElement, {
    final String? name,
  }) {
    final constructors = providerElement.constructors;
    final constructor = constructors.first;
    buffer.writeln('injectRegister.register<${providerElement.name}>(');
    buffer.writeln('${providerElement.name}(');

    for (final constructorParam in constructor.parameters) {
      final String className = constructorParam.type.getDisplayString(
        withNullability: false,
      );
      buffer.writeln('injectRegister.resolve<$className>(),');
    }

    if (name != null && name.isNotEmpty) {
      buffer.writeln('), name: "$name");');
    } else {
      buffer.writeln('));');
    }
  }

  /// Obtains all the controllers from [moduleMetadata]
  List<DartObject> _getAllControllers(final DartObject? moduleMetadata) {
    return _getAllFieldFromModuleMetadata(moduleMetadata, 'controllers');
  }

  /// Obtains all the providers from [moduleMetadata]
  List<DartObject> _getAllProviders(final DartObject? moduleMetadata) {
    return _getAllFieldFromModuleMetadata(moduleMetadata, 'providers');
  }

  List<DartObject> _getAllFieldFromModuleMetadata(
    final DartObject? moduleMetadata,
    final String field,
  ) {
    if (moduleMetadata == null) {
      return [];
    }

    final List<DartObject> imports =
        moduleMetadata.getField('imports')?.toListValue() ?? [];
    final metadataList = imports
        .map((e) => e.getField('metadata'))
        .expand((e) => _getAllFieldFromModuleMetadata(e, field))
        .toList();

    final List<DartObject> controllers =
        moduleMetadata.getField(field)?.toListValue() ?? [];

    return metadataList + controllers;
  }

  /// Sort the dependencies by a topological sort to add the dependencies
  /// for each class that requires as inversion control
  List<ClassElement> _topologicalSort(final List<ClassElement> dependencies) {
    final visited = <ClassElement>{};
    final sorted = <ClassElement>[];

    for (final dependency in dependencies) {
      _visit(dependency, visited, sorted);
    }

    return sorted.toList();
  }

  /// Marks the [dependency] as visited in [visited] set and add it also in
  /// [sorted] list
  void _visit(
    final ClassElement dependency,
    final Set<ClassElement> visited,
    final List<ClassElement> sorted,
  ) {
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

  /// Obtains the dependencies of a class by his constructor
  List<ClassElement> _getDependencies(final ClassElement clazz) {
    final dependencies = <ClassElement>[];

    final constructor = clazz.unnamedConstructor;
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

  /// Creates the 'main' method into the [buffer] by [annotation] that must be
  /// [Application]
  void _createMain(final StringBuffer buffer, final ConstantReader annotation) {
    buffer.writeln('Future<void> init() async {');

    buffer.writeln('initDependencies();');
    buffer.writeln('final injectRegister = InstanceRegister.instance;');
    buffer.writeln('final app = Dartness();');

    final applicationModule = annotation.read('module').objectValue;
    final rootModuleMetadata = applicationModule.getField('metadata');
    final allControllers = _getAllControllers(rootModuleMetadata);

    final controllerElements = allControllers
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
      buffer.writeln('await app.create(');
      _generateControllers(controllerElements, buffer);
      _generateOptions(applicationOptions, buffer);
      buffer.writeln(');');
    }

    // main end method
    buffer.writeln('}');
  }

  void _generateOptions(
    final DartObject applicationOptions,
    final StringBuffer buffer,
  ) {
    final logRequest =
        applicationOptions.getField('_logRequest')?.toBoolValue();
    final port = applicationOptions.getField('_port')?.toIntValue();
    final internetAddress =
        applicationOptions.getField('_internetAddress')?.toTypeValue();
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
