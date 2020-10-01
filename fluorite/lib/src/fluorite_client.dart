import 'package:dio/dio.dart' as d;

import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/utils.dart';

class FluoriteClient {
  final d.Dio dio;
  final logger = getLogger('client');
  FluoriteClient(this.dio) {
    initLogger();
  }

  Future<Response<T>> request<T>(Request request) async {
    logger.fine(request);
    var options = d.RequestOptions(
      baseUrl: request.baseUrl,
      path: request.path,
      data: request.body,
      method: request.method,
      queryParameters: request.parameters,
    );
    logger.fine('sending request...');
    var result = await dio.request(options.path, options: options);
    final response = Response<T>(
        status: result.statusCode,
        message: result.statusMessage,
        body: result.data);
    logger.fine(response);
    return Future.value(response);
  }
}
