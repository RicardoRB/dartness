import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/controller_generator.dart';

Builder controller(BuilderOptions options) =>
    SharedPartBuilder([ControllerGenerator()], 'controller');
