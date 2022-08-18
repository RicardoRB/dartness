import 'bind.dart';

/// Route annotation. Routes Patch requests to the specified path.
class Patch extends Bind {
  const Patch([String path = '']) : super('PATCH', path);
}
