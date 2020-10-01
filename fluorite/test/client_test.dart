import 'package:dio/dio.dart';
import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/http_method.dart';
import 'package:test/test.dart';

void main() {
  test('client', () async {
    final client = FluoriteClient(Dio());
    var request =
        Request(method: HttpMethod.GET, path: 'https://httpbin.org/get');
    await client.request(request);
  });
}
