import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/shared/providers/favorites_provider.dart';
import 'package:pixelpin/shared/widgets/wallpaper_card.dart';
import 'package:pixelpin/core/constants/app_constants.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final repo = ref.read(wallpaperRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.bgDark,
        actions: [
          if (favoriteIds.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.bgDarkCard,
                    title: const Text('Clear all favorites?',
                        style: TextStyle(color: AppColors.textPrimary)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear',
                              style: TextStyle(color: AppColors.error))),
                    ],
                  ),
                );
                if (confirmed == true) {
                  for (final id in favoriteIds.toList()) {
                    ref.read(favoritesProvider.notifier).toggle(id);
                  }
                }
              },
              child: const Text('Clear all',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
        ],
      ),
      body: favoriteIds.isEmpty
          ? _buildEmpty(context)
          : FutureBuilder<List<WallpaperModel>>(
              future: Future.wait(
                favoriteIds.map((id) => repo.getWallpaper(id)),
              ).then((list) => list.whereType<WallpaperModel>().toList()),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary));
                }
                final wallpapers = snap.data!;
                if (wallpapers.isEmpty) return _buildEmpty(context);
                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppConstants.gridCrossAxisCount,
                    childAspectRatio: AppConstants.gridAspectRatio,
                    crossAxisSpacing: AppConstants.gridSpacing,
                    mainAxisSpacing: AppConstants.gridSpacing,
                  ),
                  itemCount: wallpapers.length,
                  itemBuilder: (_, i) =>
                      WallpaperCard(wallpaper: wallpapers[i]),
                );
              },
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline_rounded,
              color: AppColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text('No favorites yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(
            'Tap the heart on any wallpaper to save it here',
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
