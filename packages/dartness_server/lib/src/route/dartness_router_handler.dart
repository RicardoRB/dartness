/// A router handler for handling request for a [_controller]
/// with his metadata and the method [MethodMirror] with the metadata.
class DartnessRouterHandler {
  final Function _function;

  DartnessRouterHandler(this._function);

  Function get handler => _function;
}
