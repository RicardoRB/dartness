import 'package:dartness/bind/annotation/trace.dart';
import 'package:test/test.dart';

void main() {
  late Trace bind;
  setUp(() => bind = Trace(""));
  test('', () {
    expect(bind.path, "");
  });
}
