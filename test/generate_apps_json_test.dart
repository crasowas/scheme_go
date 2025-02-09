// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../scripts/generate_apps_json.dart';

void main() {
  group('Validate apps_data.json file', () {
    test('apps_data.json file should exist', () {
      final File appsDataFile = File(sourceFilePath);
      expect(appsDataFile.existsSync(), isTrue,
          reason: 'apps_data.json does not exist');
    });

    test('apps_data.json should be a JSON array', () {
      final File appsDataFile = File(sourceFilePath);
      final appsData = jsonDecode(appsDataFile.readAsStringSync());
      expect(appsData, isA<List<dynamic>>(),
          reason: 'apps_data.json is not a JSON array');
    });
  });

  group('Run generate_apps_json.dart script', () {
    test('Script should execute successfully', () async {
      final ProcessResult result = await Process.run(
          'dart', ['./scripts/generate_apps_json.dart', '--pretty']);
      expect(result.exitCode, equals(0),
          reason: 'Dart script execution failed');
    }, timeout: Timeout(Duration(seconds: 60)));
  });

  group('Validate generated apps.json file', () {
    test('apps.json file should be generated', () {
      final File appsFile = File(outputFilePath);
      expect(appsFile.existsSync(), isTrue,
          reason: 'apps.json was not generated');
    });

    test('apps.json should be a JSON array', () {
      final File appsFile = File(outputFilePath);
      final apps = jsonDecode(appsFile.readAsStringSync());
      expect(apps, isA<List<dynamic>>(),
          reason: 'apps.json is not a JSON array');
    });

    test('apps.json should have the same length as apps_data.json', () {
      final File appsDataFile = File(sourceFilePath);
      final File appsFile = File(outputFilePath);

      final List<dynamic> appsData =
          jsonDecode(appsDataFile.readAsStringSync());
      final List<dynamic> apps = jsonDecode(appsFile.readAsStringSync());

      expect(apps.length, equals(appsData.length),
          reason: 'apps.json is not fully generated');
    });
  });
}
