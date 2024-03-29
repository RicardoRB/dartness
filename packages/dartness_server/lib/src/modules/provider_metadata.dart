/// Define a Dart class called ProviderMetadata.
class ProviderMetadata<T> {
  /// The class type that must be created
  final T classType;

  /// Optional name to give to the provider instance
  final String? name;

  /// [Function] to create the provider by custom code
  final Function? useFactory;

  const ProviderMetadata({
    required this.classType,
    this.name,
    this.useFactory,
  });
}
