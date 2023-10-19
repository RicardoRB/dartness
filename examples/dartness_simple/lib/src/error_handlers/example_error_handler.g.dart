// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_error_handler.dart';

// **************************************************************************
// ErrorHandlerGenerator
// **************************************************************************

extension ExampleErrorHandlerCatchers on ExampleErrorHandler {
  List<DartnessCatchError> getCatchErrors() {
    final catchErrorHandlers = <DartnessCatchError>[];
    catchErrorHandlers.add(DartnessCatchError(
      [NotFoundException],
      handleNotFoundException,
    ));
    return catchErrorHandlers;
  }
}

class ExampleDartnessErrorHandler extends DartnessErrorHandler {
  ExampleDartnessErrorHandler(ExampleErrorHandler errorHandler)
      : super(
          errorHandler,
          errorHandler.getCatchErrors(),
        );
}
