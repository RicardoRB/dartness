import 'package:dartness_server/bind.dart';
import 'package:test/test.dart';

void main() {
  late Put bind;
  setUp(() => bind = Put(""));
  test('Put path test', () {
    expect(bind.path, "");
  });
}
