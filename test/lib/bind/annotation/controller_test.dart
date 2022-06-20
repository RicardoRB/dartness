import 'package:dartness/bind/annotation/controller.dart';
import 'package:test/test.dart';

void main() {
  late Controller controller;
  setUp(() => controller = Controller(""));
  test('', () {
    expect(controller.path, "");
  });
}
