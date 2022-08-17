// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_error_handler.dart';

// **************************************************************************
// ErrorHandlerGenerator
// **************************************************************************

extension ExampleErrorHandlerCatchers on ExampleErrorHandler {
  List<DartnessErrorHandler> getCatchHandlers() {
    final catchErrorHandlers = <DartnessErrorHandler>[];
    catchErrorHandlers.add(
        DartnessErrorHandler([NotFoundException], handleNotFoundException));
    return catchErrorHandlers;
  }
}
