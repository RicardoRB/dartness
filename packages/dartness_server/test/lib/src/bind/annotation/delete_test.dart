import 'package:dartness_server/bind.dart';
import 'package:test/test.dart';

void main() {
  late Delete bind;
  setUp(() => bind = Delete(""));
  test('Delete path test', () {
    expect(bind.path, "");
  });
}