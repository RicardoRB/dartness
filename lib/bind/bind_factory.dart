import 'dart:mirrors';

import 'bind_handler.dart';

abstract class BindFactory {
  BindHandler of(final ClassMirror classMirror);
}
