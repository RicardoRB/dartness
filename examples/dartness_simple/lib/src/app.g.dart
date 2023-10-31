// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// ApplicationGenerator
// **************************************************************************

extension AppExtension on App {
  initDependencies() {
    final injectRegister = InstanceRegister.instance;
    injectRegister.register<UserController>(UserController());
    injectRegister.register<CityService>(CityService());
    injectRegister.register<CityService>(CityService(), name: "CITY_SECOND");
    injectRegister.register<CityController>(CityController(
      injectRegister.resolve<CityService>(),
    ));
    injectRegister.register<HealthController>(HealthController());
    injectRegister.register<ExampleErrorHandler>(ExampleErrorHandler());
  }

  Future<void> init() async {
    initDependencies();
    final injectRegister = InstanceRegister.instance;
    final app = Dartness();
    await app.create(
      controllers: [
        UserDartnessController(injectRegister.resolve<UserController>()),
        CityDartnessController(injectRegister.resolve<CityController>()),
        HealthDartnessController(injectRegister.resolve<HealthController>()),
      ],
      options: DartnessApplicationOptions(
        logRequest: false,
        port: 8080,
      ),
    );
  }
}
