import 'dart:convert';

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
    await _server.start();
    var dio = Dio(BaseOptions(baseUrl: _server.url));
    _client = FluoriteClient(dio);
  });

  test('test http method', () async {
    final http_methods = [
      HttpMethod.GET,
      HttpMethod.DELETE,
      HttpMethod.HEAD,
      HttpMethod.OPTIONS,
      HttpMethod.PATCH,
      HttpMethod.POST,
      HttpMethod.PUT,
    ];

    await Future.forEach(http_methods, (method) async {
      var req = Request(method: method, path: method);
      _server.enqueue(body: {'method': method});
      var result = await _client.request(req);
      if (HttpMethod.HEAD != method) {
        expect(result.body, contains(req.method));
      }
    });
  });
  test('response converter map', () async {
    _server.enqueue(
        body: json.encode({'method': HttpMethod.GET, 'n122': 'ssss'}),
        headers: {
          'Content-Type': 'application/json',
        });
    var req = Request(method: HttpMethod.GET, path: '/');
    var map = await _client.request(req);
    print(map);
  });

  test('response converter List', () async {
    _server.enqueue(body: json.encode(['1', '2', '3']), headers: {
      'Content-Type': 'application/json',
    });
    var req = Request(method: HttpMethod.GET, path: '/');
    var map = await _client.request<List, String>(req);
    print(map.body.first.runtimeType);
  });

  test('test get data from httpbin ', () async {
    var dio = Dio(BaseOptions(baseUrl: 'https://httpbin.org'));
    var client = FluoriteClient(dio);
    var req =
        Request(method: HttpMethod.GET, path: '/get', parameters: {'你好': '你好'});
    var map = await client.request(req);
    print(map);
  });
}
