// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:scheme_go/utils/console_util.dart';

const String sourceFilePath = 'apps_data.json';
const String outputFilePath = 'web/apps.json';

const String _iTunesLookupApi = 'https://itunes.apple.com/lookup';

Future<void> main(List<String> arguments) async {
  bool shouldFormat = arguments.contains('--pretty');

  final File sourceFile = File(sourceFilePath);
  if (!sourceFile.existsSync()) {
    ConsoleUtil.error('Source file not found: $sourceFilePath');
    exit(1); // Terminate the script with an error code
  }

  final List<dynamic> apps = jsonDecode(sourceFile.readAsStringSync());

  for (var app in apps) {
    final String? id = app['id'];
    if (id == null) {
      ConsoleUtil.warn('Skipping entry: Missing "id" field.');
      continue;
    }
    // Default to 'cn' if not specified
    final String country = app['country'] ?? 'cn';

    ConsoleUtil.info('Fetching app details for id: $id (country: $country)...');

    try {
      final http.Response response = await http
          .get(Uri.parse('$_iTunesLookupApi?id=$id&country=$country'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['resultCount'] > 0) {
          final Map<String, dynamic> result = jsonResponse['results'][0];

          final String name =
              result['trackName'].split(RegExp(r'[-–—（「:]'))[0].trim();
          app['name'] = name;
          app['artworkUrl100'] = result['artworkUrl100'];
          app['artworkUrl512'] = result['artworkUrl512'];

          ConsoleUtil.success('$id (name: $name) updated successfully.');
        } else {
          ConsoleUtil.warn(
              'No matching app found for $id (country: $country).');
        }
      } else {
        ConsoleUtil.error(
            'Request failed for $id (country: $country), HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      ConsoleUtil.error(
          'Network error while fetching data for id: $id (country: $country) - $e');
    }

    // Prevent rate limiting by adding a delay between requests
    await Future.delayed(Duration(milliseconds: 500));
  }

  final File outputFile = File(outputFilePath);
  if (shouldFormat) {
    outputFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(apps));
  } else {
    outputFile.writeAsStringSync(jsonEncode(apps));
  }
  ConsoleUtil.success('Successfully generated file: $outputFilePath.');
}
