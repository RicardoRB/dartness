/// An annotation to indicate what HTTP status code must be returned.
class HttpCode {
  const HttpCode(this.code);

  /// [Status code](https://restfulapi.net/http-status-codes/)
  final int code;
}
