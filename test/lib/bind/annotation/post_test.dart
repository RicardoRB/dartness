import 'package:dartness/bind/annotation/post.dart';
import 'package:test/test.dart';

void main() {
  late Post bind;
  setUp(() => bind = Post(""));
  test('', () {
    expect(bind.path, "");
  });
}
