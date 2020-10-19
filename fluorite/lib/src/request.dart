import 'package:fluorite/src/http_method.dart';
import 'package:meta/meta.dart';

@immutable
class Request {
  final String method;
  final String baseUrl;
  final String path;
  final dynamic body;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> parameters;

  const Request({
    this.method = HttpMethod.GET,
    this.baseUrl,
    this.path,
    this.body,
    this.headers = const {},
    this.parameters = const {},
  });

  Request copyWith({
    String method,
    String baseUrl,
    String path,
    dynamic body,
    Map<String, dynamic> headers,
    Map<String, dynamic> parameters,
  }) {
    return Request(
      method: method ?? this.method,
      baseUrl: baseUrl ?? this.baseUrl,
      path: path ?? this.path,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  String toString() {
    return 'Request(method: $method, baseUrl: $baseUrl, path: $path, body: $body, headers: $headers, parameters: $parameters)';
  }

  Uri buildUri() {
    Uri uri;
    final baseUrl = this.baseUrl ?? '';
    final path = this.path ?? '';
    if (path.startsWith(RegExp(r'http[s]*://'))) {
      uri = Uri.parse(path);
    } else {
      var url = (!baseUrl.endsWith('/') && !path.endsWith('/'))
          ? '$baseUrl/$path'
          : '$baseUrl$path';
      uri = Uri.parse(url);
    }

    if (uri.path.contains('//')) {
      // clear '//' in path
      uri = uri.replace(path: uri.path.replaceAll('//', '/'));
    }

    if (parameters.isNotEmpty) {
      uri = uri.replace(queryParameters: parameters);
    }
    return uri;
  }
}
