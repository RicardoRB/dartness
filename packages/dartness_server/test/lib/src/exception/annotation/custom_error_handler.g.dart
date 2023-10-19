// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_error_handler.dart';

// **************************************************************************
// ErrorHandlerGenerator
// **************************************************************************

extension CustomErrorHandlerCatchers on CustomErrorHandler {
  List<DartnessCatchError> getCatchErrors() {
    final catchErrorHandlers = <DartnessCatchError>[];
    catchErrorHandlers.add(DartnessCatchError(
      [ArgumentError],
      argumentErrorHandler,
    ));
    catchErrorHandlers.add(DartnessCatchError(
      [RangeError],
      rangeErrorHandler,
    ));
    return catchErrorHandlers;
  }
}

class CustomDartnessErrorHandler extends DartnessErrorHandler {
  CustomDartnessErrorHandler(CustomErrorHandler errorHandler)
      : super(
          errorHandler,
          errorHandler.getCatchErrors(),
        );
}
