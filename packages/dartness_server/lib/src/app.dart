import 'dart:io';

class App {
  const App({
    this.port = 3000,
    this.internetAddress,
  });

  final int port;
  final InternetAddress? internetAddress;
}
