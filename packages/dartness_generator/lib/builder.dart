import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/dartness_generator.dart';

Builder dartness(BuilderOptions options) =>
    SharedPartBuilder([DartnessGenerator()], 'dartness');
