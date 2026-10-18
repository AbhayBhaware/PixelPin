import 'package:flutter_test/flutter_test.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/data/models/category_model.dart';
import 'package:pixelpin/core/theme/app_colors.dart';

void main() {
  group('WallpaperStats Tests', () {
    test('Calculates engagement score correctly according to revenue model', () {
      const stats = WallpaperStats(
        views: 100,
        downloads: 20,
        shares: 10,
        favorites: 5,
      );

      // (100 * 1) + (20 * 5) + (10 * 3) = 100 + 100 + 30 = 230
      expect(stats.engagementScore, equals(230));
    });
  });

  group('WallpaperModel Extensions Tests', () {
    test('Determines isPortrait correctly and formats size', () {
      final now = DateTime.now();
      final wallpaper = WallpaperModel(
        id: 'test-1',
        title: 'Neon Skyline',
        category: 'Cyberpunk',
        contributorId: 'user-1',
        contributorName: 'Alex',
        cloudinaryPublicId: 'pixelpin/wallpapers/neon_skyline',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
        thumbUrl: 'https://res.cloudinary.com/demo/image/upload/sample_thumb.jpg',
        width: 1080,
        height: 2400,
        size: 2500000,
        createdAt: now,
      );

      expect(wallpaper.isPortrait, isTrue);
      expect(wallpaper.resolution, equals('1080×2400'));
      expect(wallpaper.formattedSize, equals('2.4 MB'));
      expect(
        wallpaper.optimizedThumbUrl,
        contains('/upload/f_auto,q_auto,w_400/'),
      );
      expect(
        wallpaper.optimizedPreviewUrl,
        contains('/upload/f_auto,q_auto,w_1080/'),
      );
    });
  });

  group('CategoryModel Tests', () {
    test('Creates CategoryModel with default values', () {
      const category = CategoryModel(
        id: 'cat-1',
        name: 'Abstract',
      );

      expect(category.icon, equals('🖼️'));
      expect(category.order, equals(0));
      expect(category.wallpaperCount, equals(0));
    });
  });

  group('AppColors Brand Identity Tests', () {
    test('Design system primary and accent colors match brand tokens', () {
      expect(AppColors.primary.toARGB32(), equals(0xFF7C4DFF));
      expect(AppColors.accent.toARGB32(), equals(0xFFFF6D6D));
      expect(AppColors.bgDark.toARGB32(), equals(0xFF0A0A0F));
    });
  });
}
