/// Annotation that marks a constructor parameter as a target for
/// dependence injection
class Inject {
  /// Lookup key for the provider to be injected
  final String? name;

  const Inject([this.name]);
}
