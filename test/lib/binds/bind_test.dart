import 'package:dartness/binds/bind.dart';
import 'package:dartness/binds/get.dart';
import 'package:test/test.dart';

void main() {
  late Bind bind;
  setUp(() => bind = Get(""));
  test('', () {
    expect(bind.path, "");
  });
}
