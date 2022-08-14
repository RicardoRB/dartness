import 'bind.dart';

/// Route annotation. Routes Get requests to the specified path.
class Get extends Bind {
  const Get([this.path = '']) : super(path);

  @override
  final String path;
}
