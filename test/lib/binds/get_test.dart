import 'package:dartness/binds/get.dart';
import 'package:test/test.dart';

void main() {
  late Get bind;
  setUp(() => bind = Get(""));
  test('', () {
    expect(bind.path, "");
  });
}
