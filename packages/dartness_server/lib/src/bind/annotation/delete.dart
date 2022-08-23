import 'bind.dart';

/// Route annotation for delete request.
class Delete extends Bind {
  const Delete([String path = '']) : super('DELETE', path);
}
