import 'package:dartness/bind/annotation/patch.dart';
import 'package:test/test.dart';

void main() {
  late Patch bind;
  setUp(() => bind = Patch(""));
  test('', () {
    expect(bind.path, "");
  });
}
