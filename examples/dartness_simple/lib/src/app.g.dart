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
    injectRegister.register<CityController>(
        CityController(injectRegister.resolve<CityService>(
      name: "CITY_SECOND",
    )));
    final createDioResult = Function.apply(createDio, []);
    injectRegister.register<Dio>(createDioResult);
    injectRegister
        .register<TodosService>(TodosService(injectRegister.resolve<Dio>()));
    injectRegister.register<TodosController>(
        TodosController(injectRegister.resolve<TodosService>()));
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
        TodosDartnessController(injectRegister.resolve<TodosController>()),
      ],
      options: DartnessApplicationOptions(
        logRequest: false,
        port: 8080,
      ),
    );
  }
}
