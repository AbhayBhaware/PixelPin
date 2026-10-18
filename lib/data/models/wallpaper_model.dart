import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallpaper_model.freezed.dart';
part 'wallpaper_model.g.dart';

@freezed
class WallpaperModel with _$WallpaperModel {
  const factory WallpaperModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default([]) List<String> tags,
    required String category,
    required String contributorId,
    required String contributorName,
    required String cloudinaryPublicId,
    required String imageUrl,
    required String thumbUrl,
    required int width,
    required int height,
    required int size,
    @Default('pending') String status,
    @Default('') String rejectReason,
    @Default('') String reviewedBy,
    DateTime? reviewedAt,
    @Default(WallpaperStats()) WallpaperStats stats,
    required DateTime createdAt,
    DateTime? publishedAt,
  }) = _WallpaperModel;

  factory WallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$WallpaperModelFromJson(json);

  factory WallpaperModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WallpaperModel.fromJson({
      'id': doc.id,
      ...data,
      'reviewedAt': (data['reviewedAt'] as Timestamp?)?.toDate().toIso8601String(),
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'publishedAt': (data['publishedAt'] as Timestamp?)?.toDate().toIso8601String(),
    });
  }
}

@freezed
class WallpaperStats with _$WallpaperStats {
  const factory WallpaperStats({
    @Default(0) int views,
    @Default(0) int downloads,
    @Default(0) int shares,
    @Default(0) int favorites,
  }) = _WallpaperStats;

  factory WallpaperStats.fromJson(Map<String, dynamic> json) =>
      _$WallpaperStatsFromJson(json);

  const WallpaperStats._();

  /// Engagement score for revenue distribution
  int get engagementScore =>
      (views * 1) + (downloads * 5) + (shares * 3);
}

extension WallpaperModelX on WallpaperModel {
  /// Get Cloudinary thumb URL with auto format and width optimization
  String get optimizedThumbUrl {
    return imageUrl.replaceFirst(
      '/upload/',
      '/upload/f_auto,q_auto,w_400/',
    );
  }

  /// Get Cloudinary preview URL (1080px wide)
  String get optimizedPreviewUrl {
    return imageUrl.replaceFirst(
      '/upload/',
      '/upload/f_auto,q_auto,w_1080/',
    );
  }

  /// Check if wallpaper is portrait (standard phone wallpaper)
  bool get isPortrait => height > width;

  /// Human-readable file size
  String get formattedSize {
    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    }
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Human-readable resolution
  String get resolution => '$width×$height';

  /// Aspect ratio for masonry grid layout (defaults to portrait 9:16)
  double get aspectRatio => (width > 0 && height > 0) ? width / height : 9 / 16;

  /// Check if wallpaper is ultra-HD 4K (min dimension >= 2160 or max dimension >= 3840)
  bool get is4K => width >= 3840 || height >= 3840 || (width >= 2160 && height >= 2160);

  /// Check if wallpaper is suited for AMOLED displays
  bool get isAmoled =>
      category.toLowerCase().contains('amoled') ||
      tags.any((tag) => tag.toLowerCase().contains('amoled'));

  /// Check if wallpaper was added recently (within 7 days)
  bool get isNew {
    final date = publishedAt ?? createdAt;
    return DateTime.now().difference(date).inDays <= 7;
  }
}
