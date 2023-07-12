// ignore_for_file: directives_ordering
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:dartness_generator/builder.dart' as _i2;
import 'package:source_gen/builder.dart' as _i3;
import 'dart:isolate' as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'dartness_generator:error_handler',
    [_i2.errorHandler],
    _i1.toDependentsOf(r'dartness_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'dartness_generator:controller',
    [_i2.controller],
    _i1.toDependentsOf(r'dartness_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'dartness_generator:application',
    [_i2.application],
    _i1.toDependentsOf(r'dartness_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'source_gen:combining_builder',
    [_i3.combiningBuilder],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'source_gen:part_cleanup'],
  ),
  _i1.applyPostProcess(
    r'source_gen:part_cleanup',
    _i3.partCleanup,
  ),
];
void main(
  List<String> args, [
  _i4.SendPort? sendPort,
]) async {
  var result = await _i5.run(
    args,
    _builders,
  );
  sendPort?.send(result);
  _i6.exitCode = result;
}
