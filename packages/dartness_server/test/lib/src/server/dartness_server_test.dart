import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/src/server/default_dartness_server.dart';
import 'package:test/test.dart';

void main() {
  late DefaultDartnessServer dartness;
  setUp(() => dartness = DefaultDartnessServer(8080));

}

class TestClass {}

@Controller("/")
class ControllerClass {}
