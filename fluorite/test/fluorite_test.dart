import 'dart:indexed_db';

import 'package:dio/dio.dart';
import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/http_method.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';

void main() {
  MockWebServer _server;
  FluoriteClient _client;

  setUp(() async {
    _server = MockWebServer();
    var dio = Dio(BaseOptions(baseUrl: _server.url));
    _client = FluoriteClient(dio);
  });

  test('test http method', () async {
    var req = Request(method: HttpMethod.GET);
    await _client.request(req);
  });
}
