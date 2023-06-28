import 'module_metadata.dart';

abstract class Module {
  final ModuleMetadata metadata;

  const Module(this.metadata);
}
