import '../bin/dartness.dart';
import 'example_controller.dart';

void main() async {
  final app = Dartness();
  app.addController(ExampleController());
  await app.create(
    port: 3000,
  );
}
