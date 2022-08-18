import 'bind.dart';

/// Route annotation. Routes Put requests to the specified path.
class Trace extends Bind {
  const Trace([String path = '']) : super('TRACE', path);
}
