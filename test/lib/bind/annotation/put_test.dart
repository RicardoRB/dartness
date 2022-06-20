import 'package:dartness/bind/annotation/put.dart';
import 'package:test/test.dart';

void main() {
  late Put bind;
  setUp(() => bind = Put(""));
  test('', () {
    expect(bind.path, "");
  });
}
