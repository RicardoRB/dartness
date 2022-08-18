import 'bind.dart';

/// Route annotation. Routes Put requests to the specified path.
class Put extends Bind {
  const Put([String path = '']) : super('PUT', path);
}
