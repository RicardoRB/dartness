import 'package:dartness_server/modules.dart';

/// Module's metadata class
class ModuleMetadata {
  /// Optional list of imported modules that export the providers which are
  /// required in this module.
  final Iterable<Module> imports;

  /// Optional list of controllers defined in this module which have to be
  /// instantiated.
  final Iterable<Type> controllers;

  /// Optional list of providers that will be instantiated by the Dartness injector
  /// and that may be shared at least across this module.
  final Iterable<Type> providers;

  /// Optional list of the subset of providers that are provided by this module
  /// and should be available in other modules which import this module.
  final Iterable<Type> exports;

  const ModuleMetadata({
    final Iterable<Module>? imports,
    final Iterable<Type>? controllers,
    final Iterable<Type>? providers,
    final Iterable<Type>? exports,
  })  : imports = imports ?? const [],
        controllers = controllers ?? const [],
        providers = providers ?? const [],
        exports = exports ?? const [];
}
