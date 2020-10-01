import 'package:meta/meta.dart';

@immutable
class Response<T> {
  final int status;
  final String message;
  final T body;
  Response({
    this.status,
    this.message,
    this.body,
  });

  Response<T> copyWith({
    int status,
    String message,
    T body,
  }) {
    return Response<T>(
      status: status ?? this.status,
      message: message ?? this.message,
      body: body ?? this.body,
    );
  }

  @override
  String toString() =>
      'Response(status: $status, message: $message, body: $body)';
}
