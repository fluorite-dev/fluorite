import 'package:dio/dio.dart' as dio;

import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/converter.dart';
import 'package:fluorite/src/utils.dart';

typedef ServiceFunction<T> = T Function(FluoriteClient client);

class FluoriteClient {
  static final _services = {};
  final _factorys;
  final ConverterFactory converterFactory;
  final dio.Dio dioClient;
  FluoriteClient(this.dioClient,
      {this.converterFactory = const JsonConverterFactory(),
      Map<dynamic, Function> factorys = const {}})
      : _factorys = factorys;

  Future<Response<T>> request<T, I>(Request request) async {
    logger.fine(request);
    var options = dio.RequestOptions(
      baseUrl: request.baseUrl,
      path: request.path,
      data: request.body,
      method: request.method,
      queryParameters: request.parameters,
    );

    options.responseType = dio.ResponseType.bytes;

    var result = await dioClient.requestUri(request.buildUri(),
        options: options); // TODO give an option to use orignal request method
    final response = ResponseExt.fromDio<T>(result);
    logger.fine(response);
    final value = converterFactory.convertResponse<T, I>(response);
    return value;
  }

  void initService<T>(ServiceFunction<T> init) {
    _factorys.putIfAbsent(T, () => init);
  }

  T createService<T>() {
    final s = _services[T];
    if (s == null) {
      final f = _factorys[T];
      if (f == null) {
        throw StateError('A function to initialize $T must be provided!');
      }
      return f(this);
    }
    return s;
  }
}
