import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/application_generator.dart';
import 'src/controller_generator.dart';
import 'src/error_handler_generator.dart';
import 'src/scheduler_generator.dart';

Builder controller(BuilderOptions options) =>
    SharedPartBuilder([ControllerGenerator()], 'controller');

Builder errorHandler(BuilderOptions options) =>
    SharedPartBuilder([ErrorHandlerGenerator()], 'error_handler');

Builder application(BuilderOptions options) =>
    SharedPartBuilder([ApplicationGenerator()], 'application');

Builder scheduler(BuilderOptions options) =>
    SharedPartBuilder([SchedulerGenerator()], 'scheduler');
