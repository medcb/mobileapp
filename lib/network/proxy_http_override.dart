import 'dart:io';

/// This class overrides the global proxy settings.
class CustomProxyHttpOverride extends HttpOverrides {
  /// The entire proxy server
  /// Format: "localhost:8888"
  final String proxyString;

  /// Initializer
  CustomProxyHttpOverride.withProxy(this.proxyString);

  /// Override HTTP client creation
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        assert(this.proxyString.isNotEmpty,
            'You must set a valid proxy if you enable it!');
        return "PROXY " + this.proxyString + ";";
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
