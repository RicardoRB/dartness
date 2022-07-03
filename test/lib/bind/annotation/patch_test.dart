import 'package:dartness_server/bind/annotation/patch.dart';
import 'package:test/test.dart';

void main() {
  late Patch bind;
  setUp(() => bind = Patch(""));
  test('Patch path test', () {
    expect(bind.path, "");
  });
}
