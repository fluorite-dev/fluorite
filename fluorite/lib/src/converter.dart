import 'dart:async';

import 'package:fluorite/fluorite.dart';

typedef Converter<F, T> = T Function(F value);

typedef RequestConverter = Request Function(Request request);

typedef ResponseConverter = FutureOr<Response> Function(Response response);
