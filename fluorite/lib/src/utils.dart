import 'package:logging/logging.dart';

const _logger_prefix = 'fluorite';
Logger getLogger(String name) => Logger('$_logger_prefix - $name');
void initLogger({Level level = Level.ALL}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}
