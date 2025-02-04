// Copyright (c) 2025, crasowas.
//
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';

part 'scheme_model.g.dart';

/// SchemeModel
@JsonSerializable()
class SchemeModel {
  String scheme;
  @JsonKey(defaultValue: '')
  String shortcut;
  @JsonKey(defaultValue: '')
  String desc;

  SchemeModel(this.scheme, this.shortcut, this.desc);

  factory SchemeModel.fromJson(Map<String, dynamic> json) => _$SchemeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchemeModelToJson(this);
}