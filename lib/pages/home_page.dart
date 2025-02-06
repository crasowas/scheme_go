// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/app_model.dart';
import '../services/api_service.dart';
import '../utils/url_launcher_util.dart';
import '../widgets/app_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String title = 'Scheme Go!';
  static const String githubLogoUrl =
      'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png';
  static const String githubProjectUrl =
      'https://github.com/crasowas/scheme_go';
  final TextEditingController _searchController = TextEditingController();
  List<AppModel> _apps = [];
  List<AppModel> _filteredApps = [];
  bool _isLoading = true;
  bool _isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    loadApps();
    _searchController.addListener(() {
      filterApps();
      _isTextNotEmpty = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 加载app.json数据
  void loadApps() async {
    List<AppModel> fetchedApps = await ApiService.fetchApps();
    setState(() {
      _apps = fetchedApps;
      _filteredApps = fetchedApps;
      _isLoading = false;
    });
  }

  // 搜索过滤App
  void filterApps() {
    setState(() {
      _filteredApps = _apps
          .where((app) => app.appName
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildTitle(),
        titleSpacing: 8,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              controller: _searchController,
              cursorColor: Colors.green,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '输入APP名称搜索...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                prefixIcon: Icon(Icons.search, color: Colors.green),
                suffixIcon: _isTextNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildTitle() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Image.network(
              githubLogoUrl,
              width: 36,
              height: 36,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () {
              UrlLauncherUtil.openUrl(githubProjectUrl, newTab: true);
            },
          ),
        )
      ],
    );
  }

  Widget _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double minCardWidth = 300;
                final int crossAxisCount =
                    (constraints.maxWidth / minCardWidth).floor().clamp(1, 6);
                return SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 8,
                    children: _filteredApps.map((app) {
                      return AppCardWidget(app: app);
                    }).toList(growable: false),
                  ),
                );
              },
            ),
          );
  }
}
