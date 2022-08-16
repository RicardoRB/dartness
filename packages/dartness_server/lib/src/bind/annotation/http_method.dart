/// Annotation for a bindable property.
class HttpMethod {
  const HttpMethod.delete([this.path = '']) : method = 'DELETE';

  const HttpMethod.get([this.path = '']) : method = 'GET';

  const HttpMethod.head([this.path = '']) : method = 'HEAD';

  const HttpMethod.options([this.path = '']) : method = 'OPTIONS';

  const HttpMethod.patch([this.path = '']) : method = 'PATCH';

  const HttpMethod.post([this.path = '']) : method = 'POST';

  const HttpMethod.put([this.path = '']) : method = 'PUT';

  const HttpMethod.connect([this.path = '']) : method = 'CONNECT';

  const HttpMethod.trace([this.path = '']) : method = 'TRACE';

  /// The path to bind the property to.
  /// If not set, the entire route would be by [Controller].
  final String path;

  /// The HTTP verb to bind the property to.
  final String method;

  @override
  String toString() {
    return 'HttpMethod{path: $path, method: $method}';
  }
}
