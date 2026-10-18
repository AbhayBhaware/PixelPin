// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WallpaperModelImpl _$$WallpaperModelImplFromJson(Map<String, dynamic> json) =>
    _$WallpaperModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      category: json['category'] as String,
      contributorId: json['contributorId'] as String,
      contributorName: json['contributorName'] as String,
      cloudinaryPublicId: json['cloudinaryPublicId'] as String,
      imageUrl: json['imageUrl'] as String,
      thumbUrl: json['thumbUrl'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
      rejectReason: json['rejectReason'] as String? ?? '',
      reviewedBy: json['reviewedBy'] as String? ?? '',
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      stats: json['stats'] == null
          ? const WallpaperStats()
          : WallpaperStats.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$WallpaperModelImplToJson(
  _$WallpaperModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'tags': instance.tags,
  'category': instance.category,
  'contributorId': instance.contributorId,
  'contributorName': instance.contributorName,
  'cloudinaryPublicId': instance.cloudinaryPublicId,
  'imageUrl': instance.imageUrl,
  'thumbUrl': instance.thumbUrl,
  'width': instance.width,
  'height': instance.height,
  'size': instance.size,
  'status': instance.status,
  'rejectReason': instance.rejectReason,
  'reviewedBy': instance.reviewedBy,
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
  'stats': instance.stats,
  'createdAt': instance.createdAt.toIso8601String(),
  'publishedAt': instance.publishedAt?.toIso8601String(),
};

_$WallpaperStatsImpl _$$WallpaperStatsImplFromJson(Map<String, dynamic> json) =>
    _$WallpaperStatsImpl(
      views: (json['views'] as num?)?.toInt() ?? 0,
      downloads: (json['downloads'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      favorites: (json['favorites'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WallpaperStatsImplToJson(
  _$WallpaperStatsImpl instance,
) => <String, dynamic>{
  'views': instance.views,
  'downloads': instance.downloads,
  'shares': instance.shares,
  'favorites': instance.favorites,
};
