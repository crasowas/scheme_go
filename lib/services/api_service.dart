// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/app_model.dart';
import '../utils/console_util.dart';

class ApiService {
  static const String apiUrl = '/apps.json';

  static Future<List<AppModel>> fetchApps() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List jsonData = json.decode(decodedBody);
        return jsonData
            .map((data) => AppModel.fromJson(data))
            .toList(growable: false);
      } else {
        throw Exception('Failed to load apps.json.');
      }
    } catch (e) {
      ConsoleUtil.error('API Error: $e');
      return [];
    }
  }
}
