import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;

class DartnessRequest {
  DartnessRequest(
    String method,
    Uri uri, {
    Map<String, Object>? headers,
    Object? body,
    Encoding? encoding,
  }) : this.fromShelf(
          shelf.Request(
            method,
            uri,
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );

  DartnessRequest.fromShelf(this._request);

  final shelf.Request _request;

  /// The requested url relative to the current handler path.
  Uri get url => _request.url;

  /// The original requested [Uri].
  Uri get requestedUri => _request.requestedUri;

  /// The HTTP headers with case-insensitive keys.
  /// The returned map is unmodifiable.
  Map<String, String> get headers => _request.headers;

  /// The [HttpMethod] associated with the request.
  String get method => _request.method;

  /// The body as a byte array stream.
  Stream<List<int>> bytes() => _request.read();

  /// The body as a string.
  Future<String> body() => _request.readAsString();
}
