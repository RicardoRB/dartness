import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;

class DartnessResponse {
  DartnessResponse({
    int statusCode = 200,
    String? body,
    Map<String, Object>? headers,
    Encoding? encoding,
  }) : this.fromShelf(
          shelf.Response(
            statusCode,
            body: body,
            headers: headers,
            encoding: encoding,
          ),
        );

  DartnessResponse.fromShelf(this._response);

  final shelf.Response _response;

  /// The HTTP status code of the response.
  int get statusCode => _response.statusCode;

  /// The HTTP headers with case-insensitive keys.
  /// The returned map is unmodifiable.
  Map<String, String> get headers => _response.headers;

  /// Returns a [Stream] representing the body.
  Stream<List<int>> bytes() => _response.read();

  /// Returns a Future containing the body as a string.
  Future<String> body() => _response.readAsString();
}
