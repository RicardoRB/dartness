// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// ApplicationGenerator
// **************************************************************************

extension AppExtension on App {
  initDependencies() {
    final injectRegister = InstanceRegister.instance;
    injectRegister.register<CityService>(CityService());
    injectRegister.register<CityController>(CityController(
      injectRegister.resolve<CityService>(),
    ));
    injectRegister.register<ExampleErrorHandler>(ExampleErrorHandler());
  }

  Future<void> main() async {
    final app = Dartness();
    await app.create(options: DartnessApplicationOptions());
  }
}
