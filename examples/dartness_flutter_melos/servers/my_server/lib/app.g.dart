// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// ApplicationGenerator
// **************************************************************************

extension AppExtension on App {
  initDependencies() {
    final injectRegister = InstanceRegister.instance;
    injectRegister.register<ExampleController>(ExampleController());
    final createDioResult = Function.apply(createDio, []);
    injectRegister.register<Dio>(createDioResult);
    injectRegister.register<TodosController>(
        TodosController(injectRegister.resolve<Dio>()));
  }

  Future<void> init() async {
    initDependencies();
    final injectRegister = InstanceRegister.instance;
    final app = Dartness();
    await app.create(
      controllers: [
        ExampleDartnessController(injectRegister.resolve<ExampleController>()),
        TodosDartnessController(injectRegister.resolve<TodosController>()),
      ],
      options: DartnessApplicationOptions(
        logRequest: false,
        port: 8080,
      ),
    );
  }
}
