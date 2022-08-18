import 'bind.dart';

/// Route annotation. Routes Put requests to the specified path.
class Connect extends Bind {
  const Connect([String path = '']) : super('CONNECT', path);
}
