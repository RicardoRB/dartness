import 'package:dartness_server/bind.dart';
import 'package:test/test.dart';

void main() {
  late Head bind;
  setUp(() => bind = Head(""));
  test('Head path test', () {
    expect(bind.path, "");
  });
}
