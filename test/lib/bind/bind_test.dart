import 'package:dartness/bind/annotation/bind.dart';
import 'package:dartness/bind/annotation/get.dart';
import 'package:test/test.dart';

void main() {
  late Bind bind;
  setUp(() => bind = Get(""));
  test('', () {
    expect(bind.path, "");
  });
}
