import 'package:dartness_server/bind/annotation/get.dart';
import 'package:test/test.dart';

void main() {
  late Get bind;
  setUp(() => bind = Get(""));
  test('Get path test', () {
    expect(bind.path, "");
  });
}
