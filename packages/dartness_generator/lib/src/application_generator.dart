import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/schedule.dart';
import 'package:source_gen/source_gen.dart';

class ApplicationGenerator extends GeneratorForAnnotation<Application> {
  static final _applicationType = TypeChecker.fromRuntime(Application);
  static final _injectType = TypeChecker.fromRuntime(Inject);
  static final _scheduledType = TypeChecker.fromRuntime(Scheduler);
  static final _useFactoryName = 'useFactory';
  static final _moduleName = 'module';
  static final _metadataName = 'metadata';
  static final _classTypeName = 'classType';
  static final _fieldNameName = 'name';

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
    buffer.writeln('initDependencies() {');

    buffer.writeln('final injectRegister = InstanceRegister.instance;');
    final applicationModule = annotation.read(_moduleName).objectValue;
    final moduleMetadata = applicationModule.getField(_metadataName);
    final List<DartObject> allControllers = _getAllControllers(moduleMetadata);
    final List<DartObject> allProviders = _getAllProviders(moduleMetadata);

    final List<DartObject> allInstances = [];
    allInstances.addAll(allControllers);
    allInstances.addAll(allProviders);
    final allProviderElements = allInstances
        .map((e) => e.getField(_classTypeName))
        .map((e) => e?.toTypeValue()?.element)
        .whereType<ClassElement>()
        .toList();

    final topologicalProviderElements =
        _topologicalSort(allProviderElements, allInstances);

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

      final providerObject = allInstances.firstWhere((element) =>
          element.getField(_classTypeName)?.toTypeValue()?.element ==
          providerElement);

      final useFactory = providerObject.getField(_useFactoryName);
      final hasUseFactory = useFactory?.isNull == false;
      if (hasUseFactory) {
        _registerFactory(useFactory, buffer, providerElement);
      } else {
        _registerClass(buffer, providerElement);
      }
      final Iterable<DartObject> allClassTypeProviders =
          allInstances.where((element) {
        final classType = element.getField(_classTypeName);
        final instanceElement = classType?.toTypeValue()?.element;
        return instanceElement == providerElement;
      }).where((element) {
        final name = element.getField(_fieldNameName)?.toStringValue();
        return name != null;
      });

      if (allClassTypeProviders.isNotEmpty) {
        for (final nameTypeProvider in allClassTypeProviders) {
          final nameField = nameTypeProvider.getField(_fieldNameName);
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

  void _registerFactory(
    final DartObject? useFactory,
    final StringBuffer buffer,
    final ClassElement providerElement,
  ) {
    final useFactoryFunc = useFactory?.toFunctionValue();
    if (useFactoryFunc is FunctionElement) {
      final variableResult = '${useFactoryFunc.name}Result';
      buffer.writeln('final $variableResult = ');
      if (useFactoryFunc.isAsynchronous) {
        buffer.writeln('await Function.apply(${useFactoryFunc.name},');
      } else {
        buffer.writeln('Function.apply(${useFactoryFunc.name},');
      }
      final resolves = useFactoryFunc.parameters.map((param) {
        final String className = param.type.getDisplayString(
          withNullability: false,
        );
        final inject = param.metadata
            .firstWhereOrNull((element) => element.runtimeType == Inject);
        final injectName = inject
            ?.computeConstantValue()
            ?.getField(_fieldNameName)
            ?.toStringValue();
        if (injectName != null && injectName.isNotEmpty) {
          return "injectRegister.resolve<$className>(name: '$injectName,')";
        }
        return 'injectRegister.resolve<$className>()';
      }).join(', ');
      if (resolves.isEmpty) {
        buffer.write('[]');
      } else {
        buffer.write('[$resolves]');
      }
      buffer.writeln(');');

      buffer.writeln(
          'injectRegister.register<${providerElement.name}>($variableResult);');
    }
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

    final resolves = constructor.parameters.map((constructorParam) {
      final String className = constructorParam.type.getDisplayString(
        withNullability: false,
      );
      final injectType = _injectType.firstAnnotationOfExact(constructorParam);
      final injectName = injectType?.getField(_fieldNameName)?.toStringValue();
      if (injectName != null && injectName.isNotEmpty) {
        return 'injectRegister.resolve<$className>(name: "$injectName",)';
      }
      return 'injectRegister.resolve<$className>()';
    }).join(', ');

    buffer.write(resolves);

    // Name for register
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
        .map((e) => e.getField(_metadataName))
        .expand((e) => _getAllFieldFromModuleMetadata(e, field))
        .toList();

    final List<DartObject> fieldMetadataList =
        moduleMetadata.getField(field)?.toListValue() ?? [];

    return metadataList + fieldMetadataList;
  }

  /// Sort the dependencies by a topological sort to add the dependencies
  /// for each class that requires as inversion control
  List<ClassElement> _topologicalSort(
    final List<ClassElement> classElementList,
    final List<DartObject> objects,
  ) {
    final visited = <ClassElement>{};
    final sorted = <ClassElement>[];

    for (final dependency in classElementList) {
      _visit(dependency, visited, sorted, objects);
    }

    return sorted;
  }

  /// Marks the [dependency] as visited in [visited] set and add it also in
  /// [sorted] list
  void _visit(
    final ClassElement dependency,
    final Set<ClassElement> visited,
    final List<ClassElement> sorted,
    final List<DartObject> allDependencies,
  ) {
    if (visited.contains(dependency)) {
      return;
    }

    visited.add(dependency);

    final dependencies = _getDependencies(dependency, allDependencies);

    for (final dep in dependencies) {
      _visit(dep, visited, sorted, allDependencies);
    }

    sorted.add(dependency);
  }

  /// Obtains the dependencies of a class by his constructor or
  /// by his params if using _useFactory
  List<ClassElement> _getDependencies(
    final ClassElement clazz,
    final List<DartObject> allDependencies,
  ) {
    final dependencies = <ClassElement>[];
    final foundObject = allDependencies.firstWhereOrNull((element) =>
        element.getField(_classTypeName)?.toTypeValue()?.element == clazz);
    if (foundObject == null) {
      throw Exception('${clazz.name} not registered as dependency');
    }
    final useFactoryField = foundObject.getField(_useFactoryName);
    final hasUseFactory = useFactoryField?.isNull == false;
    if (hasUseFactory) {
      final useFeatureFunction = useFactoryField?.toFunctionValue();
      final params = useFeatureFunction?.parameters ?? [];
      for (final param in params) {
        final paramElement = param.type.element;
        if (paramElement is ClassElement) {
          dependencies.add(paramElement);
        }
      }
    } else {
      final constructor =
          clazz.constructors.firstWhereOrNull((element) => !element.isFactory);
      if (constructor != null) {
        final parameters = constructor.parameters;
        for (final param in parameters) {
          final paramElement = param.type.element;
          if (paramElement is ClassElement) {
            dependencies.add(paramElement);
          }
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

    final applicationModule = annotation.read(_moduleName).objectValue;
    final rootModuleMetadata = applicationModule.getField(_metadataName);
    final allControllers = _getAllControllers(rootModuleMetadata);

    final controllerElements = allControllers
        .where((e) => e.getField(_useFactoryName)?.isNull == true)
        .map((e) => e.getField(_classTypeName))
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

    final allProviders = _getAllProviders(rootModuleMetadata);
    final allSchedulers = allProviders
        .map((e) => e.getField('classType'))
        .map((e) => e?.toTypeValue())
        .map((e) => e?.element)
        .nonNulls
        .where((e) => _scheduledType.hasAnnotationOfExact(e));

    for (final scheduler in allSchedulers) {
      buffer.writeln(
          'injectRegister.resolve<${scheduler.displayName}>().initSchedules();');
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
