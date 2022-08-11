import 'package:dartness_server/bind.dart';
import 'package:test/test.dart';

void main() {
  late Bind bind;
  setUp(() => bind = Get(""));
  test('Bind path test', () {
    expect(bind.path, "");
  });
}
