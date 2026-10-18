// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '🖼️',
      order: (json['order'] as num?)?.toInt() ?? 0,
      wallpaperCount: (json['wallpaperCount'] as num?)?.toInt() ?? 0,
      coverImageUrl: json['coverImageUrl'] as String?,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'order': instance.order,
      'wallpaperCount': instance.wallpaperCount,
      'coverImageUrl': instance.coverImageUrl,
    };
