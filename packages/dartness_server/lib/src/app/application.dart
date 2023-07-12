import '../modules/module.dart';
import '../server/dartness_application_options.dart';

abstract class Application {
  final Module module;
  final DartnessApplicationOptions options;

  const Application({
    required this.module,
    final DartnessApplicationOptions? options,
  }) : options = options ?? const DartnessApplicationOptions();
}
