// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchemeModel _$SchemeModelFromJson(Map<String, dynamic> json) => SchemeModel(
      json['scheme'] as String,
      json['shortcut'] as String? ?? '',
      json['desc'] as String? ?? '',
    );

Map<String, dynamic> _$SchemeModelToJson(SchemeModel instance) =>
    <String, dynamic>{
      'scheme': instance.scheme,
      'shortcut': instance.shortcut,
      'desc': instance.desc,
    };
