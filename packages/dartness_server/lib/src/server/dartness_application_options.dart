import 'dart:io';

class DartnessApplicationOptions {
  final bool _logRequest;

  bool get logRequest => _logRequest;
  final int _port;

  int get port => _port;
  final InternetAddress _internetAddress;

  InternetAddress get internetAddress => _internetAddress;

  DartnessApplicationOptions({
    final bool logRequest = false,
    final int port = 8080,
    final InternetAddress? internetAddress,
  })  : _logRequest = logRequest,
        _port = port,
        _internetAddress = internetAddress ?? InternetAddress.anyIPv4;
}
