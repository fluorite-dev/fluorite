import 'package:dio/dio.dart' as dio;
import 'package:meta/meta.dart';

@immutable
class Response<T> {
  final List<int> data;
  final int status;
  final String message;
  final T body;
  final Map<String, String> headers;
  Response({
    this.data,
    this.status,
    this.message,
    this.body,
    this.headers,
  });

  Response<T> copyWith({
    List<int> data,
    int status,
    String message,
    T body,
    Map<String, String> headers,
  }) {
    return Response<T>(
      data: data ?? this.data,
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
        data: res.data);
  }
}
