import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/app_generator.dart';
import 'src/controller_generator.dart';

Builder app(BuilderOptions options) =>
    SharedPartBuilder([AppGenerator()], 'app');

Builder controller(BuilderOptions options) =>
    SharedPartBuilder([ControllerGenerator()], 'controller');
