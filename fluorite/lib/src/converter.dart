import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fluorite/fluorite.dart';
import 'package:fluorite/src/utils.dart';

typedef Converter<F, T> = T Function(F value);

typedef RequestConverter = Request Function(Request request);

typedef ResponseConverter = FutureOr<Response<T>> Function<T, I>(
    Response response);

const keyConentType = 'Content-Type';
const jsonType = 'application/json';

abstract class ConverterFactory {
  const ConverterFactory();
  RequestConverter get convertRequest;
  ResponseConverter get convertResponse;
}

class JsonConverterFactory extends ConverterFactory {
  const JsonConverterFactory();
  @override
  RequestConverter get convertRequest => (Request request) => encode(request);

  @override
  ResponseConverter get convertResponse =>
      <T, I>(Response response) => decode<T, I>(response);

  Request encode(Request request) {
    var contentType = request.headers[keyConentType];
    if (contentType != null && contentType.contains(jsonType)) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  Response<T> decode<T, I>(Response response) {
    var contentType = response.headers[keyConentType];
    dynamic body = response.data;
    if (contentType != null && contentType.contains(jsonType)) {
      // If we're decoding JSON, there's some ambiguity in https://tools.ietf.org/html/rfc2616
      // about what encoding should be used if the content-type doesn't contain a 'charset'
      // parameter. See https://github.com/dart-lang/http/issues/186. In a nutshell, without
      // an explicit charset, the Dart http library will fall back to using ISO-8859-1, however,
      // https://tools.ietf.org/html/rfc8259 says that JSON must be encoded using UTF-8. So,
      // we're going to explicitly decode using UTF-8... if we don't do this, then we can easily
      // end up with our JSON string containing incorrectly decoded characters.
      body = utf8.decode(response.data);
    }

    body = _tryDecodeJsonFromBytes(body);
    if (isTypeOf<T, Iterable<I>>()) {
      body = body.cast<I>();
    } else if (isTypeOf<T, Map<String, I>>()) {
      body = body.cast<String, I>();
    }

    return response.copyWith(body: body);
  }

  dynamic _tryDecodeJsonFromBytes(List<int> bytes) {
    try {
      final data = String.fromCharCodes(Uint8List.fromList(bytes));
      return _tryDecodeJson(data);
    } catch (e) {
      return bytes;
    }
  }

  dynamic _tryDecodeJson(String data) {
    try {
      return json.decode(data);
    } catch (e) {
      return data;
    }
  }
}
