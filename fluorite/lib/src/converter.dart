import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fluorite/fluorite.dart';

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
    if (contentType?.contains(jsonType) == true) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  Response<T> decode<T, I>(Response response) {
    var contentType = response.headers[keyConentType];
    dynamic body = response.data;
    if (contentType?.contains(jsonType) == true) {
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
    final data = String.fromCharCodes(Uint8List.fromList(bytes));
    return _tryDecodeJson(data);
  }

  dynamic _tryDecodeJson(String data) {
    try {
      return json.decode(data);
    } catch (e) {
      logger.severe('trying to decode json from string', e);
      return data;
    }
  }
}
