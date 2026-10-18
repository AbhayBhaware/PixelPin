import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/shared/widgets/wallpaper_tile.dart';

/// Legacy compatibility wrapper for WallpaperTile
class WallpaperCard extends StatelessWidget {
  final WallpaperModel wallpaper;
  final bool showStats;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.showStats = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return WallpaperTile(
      wallpaper: wallpaper,
      showStats: showStats,
      isFavorite: isFavorite,
      onFavoriteToggle: onFavoriteToggle,
    );
  }
}

/// Shimmer placeholder for loading state in masonry grid
class WallpaperCardSkeleton extends StatelessWidget {
  final double aspectRatio;

  const WallpaperCardSkeleton({
    super.key,
    this.aspectRatio = 9 / 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Shimmer.fromColors(
          baseColor: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
          highlightColor: isDark ? AppColors.borderDark : AppColors.borderLight,
          child: Container(
            color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
          ),
        ),
      ),
    );
  }
}
