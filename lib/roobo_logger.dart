library roobo_logger;

import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as Log;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'ansi_parser.dart';
import 'log_console.dart';

class Logger {
  static late int size;
  static late bool writeFile;
  static late String savePath;
  static late var logger;

  static init({
    int? shakeLoggerBufferSize,
    bool? isWriteFile,
    String? path,
  }) async {
    if (shakeLoggerBufferSize != null && shakeLoggerBufferSize > 0) {
      size = shakeLoggerBufferSize;
    } else {
      size = 50;
    }
    if (isWriteFile != null) {
      writeFile = isWriteFile;
    } else {
      writeFile = false;
    }
    if (path != null) {
      savePath = path;
    } else {
      Directory tempDir = await getTemporaryDirectory();
      savePath = tempDir.path + "/log/" + DateTime.now().toString() + ".txt";
    }
    logger = Log.Logger(
      output: ExampleLogOutput(size, writeFile, savePath),
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
  }

  static void i(Object o) {
    logger.i(o.toString());
  }
}

class ExampleLogOutput extends ConsoleOutput {
  int size;
  bool writeFile;
  String savePath;
  WriteLogOutput writeLogOutput = WriteLogOutput();

  ExampleLogOutput(this.size, this.writeFile, this.savePath) {
    writeLogOutput.savePath = savePath;
    writeLogOutput.addListener(() {
      if (writeLogOutput._outputEventBuffer.length > 0 && !writeLogOutput.isWriting) writeLogOutput.write2File();
    });
  }

  @override
  void output(OutputEvent event) {
    super.output(event);
    LogConsole.add(event, bufferSize: size);
    writeLogOutput.add(event);
  }
}

class WriteLogOutput extends ChangeNotifier {
  ListQueue<OutputEvent> _outputEventBuffer = ListQueue();
  String savePath = "";
  bool isWriting = false;

  Future<void> add(OutputEvent outputEvent) async {
    _outputEventBuffer.add(outputEvent);
    notifyListeners();
  }

  write2File() async {
    isWriting = true;
    final file = File('$savePath');
    print(file.path);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    var parser = AnsiParser(false);
    var text = _outputEventBuffer.first.lines.join('\n');
    parser.parseFileInputString(text);
    await file.writeAsString('\n${parser.spansString}', mode: FileMode.append);
    _outputEventBuffer.removeFirst();
    isWriting = false;
    notifyListeners();
  }
}
