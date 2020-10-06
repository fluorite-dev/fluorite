import 'package:logging/logging.dart';

const _logger_prefix = 'fluorite';
Logger getLogger(String name) => Logger('$_logger_prefix - $name');

final logger = Logger(_logger_prefix);

bool isTypeOf<T, I>() => _TypeChecker<T>() is _TypeChecker<I>;

class _TypeChecker<T> {}
