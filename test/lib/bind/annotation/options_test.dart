import 'package:dartness_server/bind/annotation/options.dart';
import 'package:test/test.dart';

void main() {
  late Options bind;
  setUp(() => bind = Options(""));
  test('Options path test', () {
    expect(bind.path, "");
  });
}
