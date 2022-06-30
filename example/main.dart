import 'package:dartness/dartness.dart';

import 'example_controller.dart';

void main() async {
  final app = Dartness(
    port: 3000,
  );
  app.addController(ExampleController());
  await app.create();
}
