library roobo_logger;

import 'package:logger/logger.dart' as Log;
import 'package:logger/logger.dart';

import 'log_console.dart';

class Logger {
  static var logger = Log.Logger(
    output: ExampleLogOutput(),
    printer: PrettyPrinter(
        methodCount: 2,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 120,
        // width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  static void i(Object o) {
    logger.i(o.toString());
  }
}

class ExampleLogOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    super.output(event);
    LogConsole.add(event);
  }
}
