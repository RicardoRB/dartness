import '../modules/module.dart';
import '../server/dartness_application_options.dart';

/// App annotation in order to create an application
class Application {
  /// Root module
  final Module module;

  /// Application options
  final DartnessApplicationOptions options;

  const Application({
    required this.module,
    final DartnessApplicationOptions? options,
  }) : options = options ?? const DartnessApplicationOptions();
}
