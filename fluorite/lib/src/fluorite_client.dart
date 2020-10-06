import 'package:dio/dio.dart' as d;

import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/converter.dart';
import 'package:fluorite/src/utils.dart';

class FluoriteClient {
  final ConverterFactory converterFactory;
  final d.Dio dio;
  final logger = getLogger('client');
  FluoriteClient(this.dio,
      {this.converterFactory = const JsonConverterFactory()}) {
    initLogger();
  }

  Future<Response<T>> request<T, I>(Request request) async {
    logger.fine(request);
    var options = d.RequestOptions(
      baseUrl: request.baseUrl,
      path: request.path,
      data: request.body,
      method: request.method,
      queryParameters: request.parameters,
    );

    options.responseType = d.ResponseType.bytes;

    var result = await dio.requestUri(request.buildUri(),
        options: options); // TODO give an option to use orignal request method
    final response = ResponseExt.fromDio<T>(result);
    logger.fine(response);
    final value = converterFactory.convertResponse<T, I>(response);
    return value;
  }
}
