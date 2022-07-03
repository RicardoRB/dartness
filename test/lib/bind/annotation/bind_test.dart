import 'package:dartness_server/bind/annotation/bind.dart';
import 'package:dartness_server/bind/annotation/get.dart';
import 'package:test/test.dart';

void main() {
  late Bind bind;
  setUp(() => bind = Get(""));
  test('Bind path test', () {
    expect(bind.path, "");
  });
}
