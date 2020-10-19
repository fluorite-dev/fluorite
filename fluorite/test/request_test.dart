import 'package:fluorite/fluorite.dart';
import 'package:test/test.dart';

void main() {
  test('request default value', () {
    var r = Request();
    expect(r.method, equals(HttpMethod.GET));
    expect(r.headers, equals(const {}));
    expect(r.parameters, equals(const {}));
    expect(r.body, isNull);
  });

  test('build request uri', () {
    var r = Request();
    expect(r.buildUri(), equals(Uri.parse('/')));

    r = Request(baseUrl: 'https://httpbin.org', path: 'get');
    expect(r.buildUri(), Uri.parse('https://httpbin.org/get'));

    r = Request(baseUrl: 'https://httpbin.org/', path: '/get');
    expect(r.buildUri(), Uri.parse('https://httpbin.org/get'));

    r = Request(
        baseUrl: 'https://httpbin.org',
        path: 'get?hello=world',
        parameters: {'hello': 'hello world'});
    expect(
        r.buildUri(), Uri.parse('https://httpbin.org/get?hello=hello+world'));

    r = Request(
        baseUrl: 'https://httpbin.org',
        path: 'get?hello=good',
        parameters: {
          'hello': ['hello', 'world']
        });

    expect(r.buildUri().toString(),
        'https://httpbin.org/get?hello=hello&hello=world');

    r = Request(path: 'https://httpbibn.org/');
    expect(r.buildUri(), Uri.parse('https://httpbibn.org/'));
  });
}
