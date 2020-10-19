import 'package:dio/dio.dart' hide Response;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'package:fluorite/fluorite.dart';

abstract class HttpBinService {
  Future<Response> httpGet(String url);
}

class HttpBinServiceImpl implements HttpBinService {
  final FluoriteClient client;
  HttpBinServiceImpl({
    @required this.client,
  });

  @override
  Future<Response> httpGet(String url) async {
    final request = Request(path: url);
    return client.request(request);
  }
}

void main(List<String> args) async {
  Logger.root.onRecord.listen((event) {
    print(event);
  });
  final logger = getLogger('example');
  logger.info('hello example');

  final client = FluoriteClient(Dio(), factorys: {
    HttpBinService: (client) => HttpBinServiceImpl(client: client)
  });
  final s = client.createService<HttpBinService>();
  final result = await s.httpGet('https://httpbin.org/get');
  logger.info(result);
}
