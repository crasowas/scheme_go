// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

class ConsoleUtil {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _green = '\x1B[32m';

  static void write(String message) {
    stdout.write(message);
  }

  static void writeln(String message) {
    stdout.writeln(message);
  }

  static void info(String message) {
    stdout.writeln(message);
  }

  static void warn(String message) {
    stdout.writeln('$_yellow$message$_reset');
  }

  static void error(String message) {
    stdout.writeln('$_red$message$_reset');
  }

  static void success(String message) {
    stdout.writeln('$_green$message$_reset');
  }

  static String? readLineSync({String prompt = ''}) {
    if (prompt.isNotEmpty) {
      stdout.write(prompt);
    }
    return stdin.readLineSync();
  }
}
