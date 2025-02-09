// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:html' as html show window;

class UrlLauncherUtil {
  static void openUrl(String url, {bool newTab = false}) {
    html.window.open(url, newTab ? '_blank' : '_self');
  }
}
