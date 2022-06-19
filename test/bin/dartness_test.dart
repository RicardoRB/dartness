import 'package:dartness/controller.dart';
import 'package:test/test.dart';

import '../../bin/dartness.dart';

void main() {
  late Dartness dartness;
  setUp(() => dartness = Dartness());

  test(
      ""
      "GIVEN a String "
      "WHEN addController "
      "THEN throw ArgumentError"
      "", () {
    final actual = "random object";
    expect(() => dartness.addController(actual), throwsArgumentError);
  });

  test(
      ""
      "GIVEN a Number "
      "WHEN addController "
      "THEN throw ArgumentError"
      "", () {
    final actual = 1;
    expect(() => dartness.addController(actual), throwsArgumentError);
  });

  test(
      ""
      "GIVEN an Object without annotation "
      "WHEN addController "
      "THEN throw ArgumentError"
      "", () {
    final actual = TestClass();
    expect(() => dartness.addController(actual), throwsArgumentError);
  });

  test(
      ""
      "GIVEN an Object with annotation "
      "WHEN addController "
      "THEN add it to controllers"
      "", () {
    final actual = ControllerClass();
    final expected = {actual};
    dartness.addController(actual);
    expect(expected, dartness.controllers);
  });
}

class TestClass {}

@Controller("")
class ControllerClass {}
