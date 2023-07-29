// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// ApplicationGenerator
// **************************************************************************

extension AppExtension on App {
  initDependencies() {
    final injectRegister = InstanceRegister.instance;
  }

  Future<void> main() async {
    initDependencies();
    final injectRegister = InstanceRegister.instance;
    final app = Dartness();
    await app.create(
      controllers: [],
      options: DartnessApplicationOptions(),
    );
  }
}
