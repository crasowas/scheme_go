// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';

import 'scheme_model.dart';

part 'app_model.g.dart';

/// AppModel
@JsonSerializable()
class AppModel {
  String appId;
  @JsonKey(defaultValue: '')
  String appName;
  @JsonKey(defaultValue: '')
  String artworkUrl100;
  @JsonKey(defaultValue: '')
  String artworkUrl512;
  @JsonKey(defaultValue: [])
  List<SchemeModel> schemes;

  AppModel(this.appId, this.appName, this.artworkUrl100, this.artworkUrl512,
      this.schemes);

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppModelToJson(this);
}
