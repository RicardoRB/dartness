import 'bind.dart';

/// Route annotation. Routes Head requests to the specified path.
class Head extends Bind {
  const Head([String path = '']) : super('HEAD', path);
}
