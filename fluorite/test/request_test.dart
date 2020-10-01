import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/http_method.dart';
import 'package:test/test.dart';

void main() {
  test('request default value', () {
    var r = Request();
    expect(r.method, equals(HttpMethod.GET));
    expect(r.headers, equals(const {}));
    expect(r.parameters, equals(const {}));
    expect(r.body, isNull);
  });
}
