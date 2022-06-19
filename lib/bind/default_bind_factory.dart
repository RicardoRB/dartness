import 'dart:mirrors';

import 'package:dartness/bind/bind_factory.dart';
import 'package:dartness/bind/bind_handler.dart';

import 'annotation/get.dart';
import 'get_handler.dart';

class DefaultBindFactory implements BindFactory {
  static final _binds = {
    Get: GetHandler(),
  };

  @override
  BindHandler of(final ClassMirror classMirror) {
    if (classMirror == reflectClass(Get)) {
      return _binds[Get]!;
    } else {
      throw ArgumentError.value(
          classMirror, 'classMirror', "class mirror not found $classMirror");
    }
  }
}
