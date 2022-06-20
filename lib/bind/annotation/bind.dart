/// Route parent annotation.
abstract class Bind {
  const Bind(this.path);

  final String path;

  @override
  String toString() {
    return runtimeType.toString().toUpperCase();
  }
}
