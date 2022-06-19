import 'bind.dart';

class Get extends Bind {
  const Get(super.path);

  @override
  String toString() {
    return runtimeType.toString().toUpperCase();
  }
}
