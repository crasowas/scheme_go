// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const String appDataPath = 'apps_data.json';
const String apiUrl = 'https://itunes.apple.com/search?term=';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('❌ Please enter the name of the app to search.');
    print('Example: dart run ./scripts/add_app_data.dart "APP名称" cn');
    exit(1); // Terminate the script with an error code
  }

  final String appName = arguments[0];
  final String country = arguments.length > 1 ? arguments[1] : 'cn';

  final File appDataFile = File(appDataPath);
  if (!appDataFile.existsSync()) {
    print('❌ Error: $appDataPath not found.');
    exit(1); // Terminate the script with an error code
  }

  List<dynamic> apps = jsonDecode(appDataFile.readAsStringSync());

  print('\n🔍 Searching for "$appName" ($country)...');

  final response = await http.get(
      Uri.parse('$apiUrl$appName&country=$country&entity=software&limit=5'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    if (json['resultCount'] > 0) {
      final appsData = json['results'];
      for (var i = 0; i < appsData.length; ++i) {
        final data = appsData[i];
        print(
            '${i + 1}. ${data['trackName']} - id: ${data['trackId']} - bundleId: ${data['bundleId']}');
      }

      print('\nEnter the number of the app you want to choose: ');
      final String? input = stdin.readLineSync();

      if (input == null || input.isEmpty) {
        print('❌ Invalid selection.');
        return;
      }

      final int? index = int.tryParse(input);
      if (index == null || index < 1 || index > appsData.length) {
        print(
            '❌ Please enter a valid number between 1 and ${appsData.length}.');
        return;
      }

      final appData = appsData[index - 1];
      final String appId = appData['trackId'].toString();
      final String appName = appData['trackName'];
      final bool isExit = apps
          .where((e) => e['appId'] == appId)
          .toList(growable: false)
          .isNotEmpty;

      if (isExit) {
        print('⚠️ $appName ($appId) - Already exists.');
      } else {
        apps.add({
          'appId': appId,
          'schemes': [
            {
              'scheme': '://',
              'shortcut': 'https://www.icloud.com/shortcuts/',
            }
          ]
        });
        appDataFile
            .writeAsStringSync(JsonEncoder.withIndent('  ').convert(apps));
        print('✅ Successfully added $appName ($appId).');
      }
    } else {
      print('⚠️ $appName - Not found.');
    }
  } else {
    print(
        '❌ $appName - Request failed with status code: ${response.statusCode}');
  }
}
