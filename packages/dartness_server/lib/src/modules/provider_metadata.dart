/// Define a Dart class called ProviderMetadata.
class ProviderMetadata {
  /// The class type that must be created
  final Type classType;

  /// Optional name to give to the provider instance
  final String? name;

  /// [Function] to create the provider by custom code
  final Function? useFactory;

  const ProviderMetadata({
    required this.classType,
    this.name,
    this.useFactory,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderMetadata &&
          runtimeType == other.runtimeType &&
          classType == other.classType &&
          name == other.name &&
          useFactory == other.useFactory;

  @override
  int get hashCode => classType.hashCode ^ name.hashCode ^ useFactory.hashCode;
}
