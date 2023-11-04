// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// ApplicationGenerator
// **************************************************************************

extension AppExtension on App {
  initDependencies() {
    final injectRegister = InstanceRegister.instance;
    injectRegister.register<ExampleController>(ExampleController());
  }

  Future<void> init() async {
    initDependencies();
    final injectRegister = InstanceRegister.instance;
    final app = Dartness();
    await app.create(
      controllers: [
        ExampleDartnessController(injectRegister.resolve<ExampleController>()),
      ],
      options: DartnessApplicationOptions(
        logRequest: false,
        port: 3000,
      ),
    );
  }
}
