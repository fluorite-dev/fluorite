import 'package:meta/meta.dart';
import 'package:dio/dio.dart' as dio;

@immutable
class Response<T> {
  final int status;
  final String message;
  final T body;
  final Map<String, String> headers;
  Response({
    this.status,
    this.message,
    this.body,
    this.headers,
  });

  Response<T> copyWith({
    int status,
    String message,
    T body,
    Map<String, String> headers,
  }) {
    return Response<T>(
      status: status ?? this.status,
      message: message ?? this.message,
      body: body ?? this.body,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() {
    return 'Response(status: $status, message: $message, body: $body, headers: $headers)';
  }
}

extension ResponseExt on Response {
  static Response<T> fromDio<T>(dio.Response res) {
    return Response<T>(
        status: res.statusCode,
        message: res.statusMessage,
        headers: res.headers.map.map(
          (key, value) => MapEntry(key, value.join()),
        ),
        body: res.data);
  }
}
