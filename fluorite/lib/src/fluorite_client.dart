import 'package:dio/dio.dart' as dio;

import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/converter.dart';
import 'package:fluorite/src/utils.dart';

class FluoriteClient {
  final ConverterFactory converterFactory;
  final dio.Dio dioClient;
  FluoriteClient(this.dioClient,
      {this.converterFactory = const JsonConverterFactory()});

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
}
