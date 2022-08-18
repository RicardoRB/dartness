import 'bind.dart';

/// Route annotation. Routes Post requests to the specified path.
class Post extends Bind {
  const Post([String path = '']) : super('POST', path);
}
