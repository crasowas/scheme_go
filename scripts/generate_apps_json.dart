// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const String sourcePath = 'apps_data.json';
const String distPath = 'web/apps.json';
const String apiUrl = 'https://itunes.apple.com/lookup?id=';

Future<void> main() async {
  final File sourceFile = File(sourcePath);
  if (!sourceFile.existsSync()) {
    print('❌ Error: $sourcePath not found.');
    exit(1); // Terminate the script with an error code
  }

  List<dynamic> apps = jsonDecode(sourceFile.readAsStringSync());

  for (var app in apps) {
    final appId = app['appId'];
    final String country =
        app['country'] ?? 'cn'; // Default to 'cn' if not specified
    final response =
        await http.get(Uri.parse('$apiUrl$appId&country=$country'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['resultCount'] > 0) {
        final appData = json['results'][0];
        final String appName = appData['trackName'].split('-')[0].trim();
        app['appName'] = appName;
        app['artworkUrl100'] = appData['artworkUrl100'];
        app['artworkUrl512'] = appData['artworkUrl512'];
        print('✅ $appId - $appName Updated successfully.');
      } else {
        print('⚠️ $appId - Not found.');
      }
    } else {
      print(
          '❌ $appId - Request failed with status code: ${response.statusCode}');
    }

    // Prevent rate limiting by adding a delay between requests
    await Future.delayed(Duration(milliseconds: 500));
  }

  final File distFile = File(distPath);
  distFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(apps));
  print('✅ Successfully generated $distPath.');
}
