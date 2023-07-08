import 'package:dartness_server/src/modules/modules.dart';
import 'package:dartness_server/src/route/route.dart';

/// Module's metadata class
class ModuleMetadata {
  /// Optional list of imported modules that export the providers which are
  /// required in this module.
  final Iterable<Module> _imports;

  Iterable<Module> get imports => _imports;

  /// Optional list of controllers defined in this module which have to be
  /// instantiated.
  final Iterable<DartnessController> _controllers;

  Iterable<DartnessController> get controllers => _controllers;

  /// Optional list of providers that will be instantiated by the Dartness injector
  /// and that may be shared at least across this module.
  final Iterable<Object> _providers;

  Iterable<Object> get providers => _providers;

  /// Optional list of the subset of providers that are provided by this module
  /// and should be available in other modules which import this module.
  final Iterable<Object> _exports;

  Iterable<Object> get exports => _exports;

  const ModuleMetadata({
    final Iterable<Module>? imports,
    final Iterable<DartnessController>? controllers,
    final Iterable<Object>? providers,
    final Iterable<Object>? exports,
  })  : _imports = imports ?? const [],
        _controllers = controllers ?? const [],
        _providers = providers ?? const [],
        _exports = exports ?? const [];
}
