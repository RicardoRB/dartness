import 'package:dartness_server/bind.dart';
import 'package:test/test.dart';

void main() {
  late Post bind;
  setUp(() => bind = Post(""));
  test('Post path test', () {
    expect(bind.path, "");
  });
}