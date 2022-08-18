import 'bind.dart';

/// Route annotation. Routes Options requests to the specified path.
class Options extends Bind {
  const Options([String path = '']) : super('OPTIONS', path);
}
