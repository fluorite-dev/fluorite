import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluorite/fluorite.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:logging/logging.dart';

void main() {
  MockWebServer _server;
  FluoriteClient _client;

  setUp(() async {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
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
          kConentType: jsonType,
        });
    var req = Request(method: HttpMethod.GET, path: '/');
    var map = await _client.request(req);
    print(map);
  });

  test('response converter List', () async {
    final list = ['abc', 'abc', 'abc'];
    _server.enqueue(body: json.encode(list), headers: {
      kConentType: jsonType,
    });
    var req = Request(method: HttpMethod.GET, path: '/');
    var result = await _client.request<List, String>(req);
    expect(result.body, isNotEmpty);
    expect(result.body.first.runtimeType, String);
    expect(result.body, ['abc', 'abc', 'abc']);
  });

  test('test get data from httpbin ', () async {
    final args = {'a': 'b', '你好': '不好'};
    var dio = Dio(BaseOptions(baseUrl: 'https://httpbin.org'));
    dio.interceptors.add(LogInterceptor());
    var client = FluoriteClient(dio);
    var req = Request(method: HttpMethod.GET, path: '/get', parameters: args);
    var result = await client.request(req);
    expect(result.status, 200);
    expect(result.body['args'], args);
  });
}
