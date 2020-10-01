import 'package:dio/dio.dart' as d;

import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/utils.dart';

class FluoriteClient {
  final dio = d.Dio();
  final logger = getLogger('client');
  FluoriteClient() {
    initLogger();
  }

  Future<Response<T>> request<T>(Request request) async {
    logger.finest(request);
    var options = d.RequestOptions(
      baseUrl: request.baseUrl,
      path: request.path,
      data: request.body,
      method: request.method,
      queryParameters: request.parameters,
    );
    logger.fine('send request...');
    var result = await dio.request(options.path, options: options);
    logger.finest('''response: {
          status: ${result.statusCode}, 
          message: ${result.statusMessage},
          extra: ${result.extra}
        }''');

    final response = Response<T>(
        status: result.statusCode,
        message: result.statusMessage,
        body: result.data);
    logger.fine(response);
    return Future.value(response);
  }
}
