import 'package:dartness/bind/annotation/options.dart';
import 'package:test/test.dart';

void main() {
  late Options bind;
  setUp(() => bind = Options(""));
  test('', () {
    expect(bind.path, "");
  });
}
