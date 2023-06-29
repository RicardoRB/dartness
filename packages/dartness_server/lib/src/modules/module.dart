import 'module_metadata.dart';

/// Module class that accepts different metadata
abstract class Module {
  final ModuleMetadata metadata;

  const Module(this.metadata);
}
