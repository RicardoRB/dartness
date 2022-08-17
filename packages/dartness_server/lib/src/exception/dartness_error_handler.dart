class DartnessErrorHandler {
  DartnessErrorHandler(this.errorTypes, this.handler);

  final List<Type> errorTypes;
  final Function handler;

  bool canHandle(final Error errorCatch) =>
      errorTypes.any((errorType) => errorType == errorCatch.runtimeType);
}
