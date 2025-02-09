// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:image_downloader_web/image_downloader_web.dart';

import '../models/app_model.dart';
import '../models/scheme_model.dart';
import '../utils/url_launcher_util.dart';

class AppCardWidget extends StatelessWidget {
  final AppModel app;

  const AppCardWidget({super.key, required this.app});

  void _downloadImage(String url, String fileName) {
    WebImageDownloader.downloadImageFromWeb(url, name: fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    app.artworkUrl100,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      UrlLauncherUtil.openUrl('itms-apps://itunes.apple.com/app/${app.id}');
                    },
                    child: Text(
                      app.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.download, color: Colors.white, size: 16),
                  label: Text(
                    'App图标',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    minimumSize: Size(0, 38),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    _downloadImage(app.artworkUrl512, '${app.name}.png');
                  },
                )
              ],
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: app.schemes
                  .map((scheme) => _buildSchemeItem(scheme))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeItem(SchemeModel scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: _buildSchemeDetail(scheme),
        ),
        SizedBox(width: 16),
        if (scheme.shortcut.isNotEmpty)
          TextButton.icon(
            iconAlignment: IconAlignment.end,
            icon: Icon(Icons.arrow_circle_right, color: Colors.white, size: 16),
            label: Text(
              'Shortcut',
              style: TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              minimumSize: Size(0, 32),
              backgroundColor: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              UrlLauncherUtil.openUrl(scheme.shortcut);
            },
          )
      ],
    );
  }

  Widget _buildSchemeDetail(SchemeModel scheme) {
    final List<Widget> children = <Widget>[];
    children.add(
      GestureDetector(
        onTap: () {
          UrlLauncherUtil.openUrl(scheme.scheme);
        },
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: <TextSpan>[
              TextSpan(text: scheme.scheme.split(':')[0]),
              TextSpan(text: ':', style: TextStyle(letterSpacing: 2.5)),
              TextSpan(text: scheme.scheme.split(':')[1]),
            ],
          ),
        ),
      ),
    );
    if (scheme.desc.isNotEmpty) {
      children.add(SizedBox(height: 2));
      children.add(
        Text(
          scheme.desc,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
