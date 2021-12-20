# roobo_logger

roobo log输出类

## Getting Started

格式化输出log

## use

```text
  Logger.i("内容");
```

## 样式

```text
  Log.Logger(printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
    ),
)
```