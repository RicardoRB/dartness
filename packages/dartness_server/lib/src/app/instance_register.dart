class InstanceRegister {
  static final InstanceRegister instance = InstanceRegister._();
  static final Map<Type, Map<String, dynamic>> _dependencies = {};
  static final Map<Type, dynamic> _singletons = {};

  InstanceRegister._();

  T resolve<T>({String name = '', bool singleton = false}) {
    if (singleton && _singletons.containsKey(T)) {
      return _singletons[T] as T;
    }
    if (_dependencies.containsKey(T)) {
      final dependencies = _dependencies[T]!;
      if (dependencies.containsKey(name)) {
        final instance = dependencies[name]!;
        if (singleton) {
          _singletons[T] = instance;
        }
        return instance as T;
      }
      throw Exception("Dependency not registered with name '$name': $T");
    }
    throw Exception("Dependency not registered: $T");
  }

  void register<T>(T instance, {String name = '', bool singleton = false}) {
    if (!_dependencies.containsKey(T)) {
      _dependencies[T] = {};
    }
    _dependencies[T]![name] = instance;
    if (singleton) {
      _singletons[T] = instance;
    }
  }
}
