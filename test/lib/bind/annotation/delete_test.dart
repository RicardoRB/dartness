import 'package:dartness/bind/annotation/delete.dart';
import 'package:test/test.dart';

void main() {
  late Delete bind;
  setUp(() => bind = Delete(""));
  test('', () {
    expect(bind.path, "");
  });
}
