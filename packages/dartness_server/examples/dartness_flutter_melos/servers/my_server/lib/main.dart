import 'package:dartness_server/dartness.dart';

import 'example_controller.dart';

void main() async {
  final app = Dartness(
    port: 3000,
    controllers: [ExampleController()],
  );
  await app.create();
}
