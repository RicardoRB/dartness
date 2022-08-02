import 'package:dartness_server/src/dartness.dart';

import 'example_controller.dart';

void main() async {
  final app = Dartness(
    port: 3000,
    controllers: [ExampleController()],
  );
  // As optional, you can also use app.addController(ExampleController());
  // app.addController(ExampleController());
  await app.create();
}
