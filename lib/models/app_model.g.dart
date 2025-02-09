// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppModel _$AppModelFromJson(Map<String, dynamic> json) => AppModel(
      json['id'] as String,
      json['name'] as String? ?? '',
      json['artworkUrl100'] as String? ?? '',
      json['artworkUrl512'] as String? ?? '',
      (json['schemes'] as List<dynamic>?)
              ?.map((e) => SchemeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AppModelToJson(AppModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artworkUrl100': instance.artworkUrl100,
      'artworkUrl512': instance.artworkUrl512,
      'schemes': instance.schemes,
    };
