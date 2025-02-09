// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:scheme_go/utils/console_util.dart';

import 'generate_apps_json.dart' show sourceFilePath;

const String _iTunesSearchApi = 'https://itunes.apple.com/search';

Future<void> main(List<String> arguments) async {
  ConsoleUtil.writeln('');

  if (arguments.isEmpty) {
    ConsoleUtil.info(
        'Usage: dart run ./scripts/add_app_data.dart <app_name> [country]');
    ConsoleUtil.info(
        'Example: dart run ./scripts/add_app_data.dart "Google" cn');
    exit(1); // Terminate the script with an error code
  }

  final String name = arguments[0];
  final String country = arguments.length > 1 ? arguments[1] : 'cn';

  final File sourceFile = File(sourceFilePath);
  if (!sourceFile.existsSync()) {
    ConsoleUtil.error('App data file not found: $sourceFilePath');
    exit(1); // Terminate the script with an error code
  }

  final List<dynamic> apps = jsonDecode(sourceFile.readAsStringSync());

  ConsoleUtil.info('Searching for $name (country: $country)...');

  try {
    final http.Response response = await http.get(Uri.parse(
        '$_iTunesSearchApi?term=$name&country=$country&entity=software&limit=5'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['resultCount'] > 0) {
        final List<dynamic> searchResults = jsonResponse['results'];

        for (var i = 0; i < searchResults.length; ++i) {
          final Map<String, dynamic> result = searchResults[i];
          ConsoleUtil.info(
              '${i + 1}. ${result['trackName']} | id: ${result['trackId']} | bundle id: ${result['bundleId']}');
        }

        final String? userInput = ConsoleUtil.readLineSync(
            prompt: '\nEnter the number of the app you want to add: ');
        ConsoleUtil.writeln('');

        final int? selectedIndex =
            userInput != null ? int.tryParse(userInput) : null;
        if (selectedIndex == null ||
            selectedIndex < 1 ||
            selectedIndex > searchResults.length) {
          ConsoleUtil.error(
              'Please enter a valid number between 1 and ${searchResults.length}.');
          return;
        }

        final Map<String, dynamic> selectedApp =
            searchResults[selectedIndex - 1];
        final String selectedId = selectedApp['trackId'].toString();
        final String selectedName = selectedApp['trackName'];

        final bool appExists = apps.any((app) => app['id'] == selectedId);
        if (appExists) {
          ConsoleUtil.warn('$selectedName (id: $selectedId) already exists.');
        } else {
          apps.add({
            'id': selectedId,
            if (country != 'cn') 'country': country,
            'schemes': [
              {
                'scheme': '://',
                'shortcut': 'https://www.icloud.com/shortcuts/',
              }
            ]
          });

          sourceFile
              .writeAsStringSync(JsonEncoder.withIndent('  ').convert(apps));
          ConsoleUtil.success(
              'Successfully added $selectedName (id: $selectedId).');
        }
      } else {
        ConsoleUtil.warn(
            'No matching app found for $name (country: $country).');
      }
    } else {
      ConsoleUtil.error(
          'Request failed for $name (country: $country), HTTP Status Code: ${response.statusCode}');
    }
  } catch (e) {
    ConsoleUtil.error(
        'Network error while searching data for name: $name (country: $country) - $e');
  }
}
