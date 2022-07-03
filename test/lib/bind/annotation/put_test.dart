import 'package:dartness_server/bind/annotation/put.dart';
import 'package:test/test.dart';

void main() {
  late Put bind;
  setUp(() => bind = Put(""));
  test('Put path test', () {
    expect(bind.path, "");
  });
}
