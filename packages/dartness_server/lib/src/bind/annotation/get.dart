import 'bind.dart';

/// Route annotation. Routes Get requests to the specified path.
class Get extends Bind {
  const Get([String path = '']) : super('GET', path);
}
