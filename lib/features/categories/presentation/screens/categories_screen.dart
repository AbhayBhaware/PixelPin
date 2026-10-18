import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/core/constants/app_constants.dart';
import 'package:pixelpin/data/models/category_model.dart';
import 'package:pixelpin/shared/widgets/wallpaper_card.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';

final _categoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  return FirebaseFirestore.instance
      .collection(AppConstants.categoriesCollection)
      .orderBy('order')
      .snapshots()
      .map((snap) =>
          snap.docs.map((d) => CategoryModel.fromFirestore(d)).toList());
});

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String? _selectedCategoryId;
  List<WallpaperModel> _wallpapers = [];
  bool _loading = false;

  Future<void> _loadCategory(String categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _loading = true;
    });
    try {
      final results = await ref
          .read(wallpaperRepositoryProvider)
          .getByCategory(categoryId);
      if (mounted) setState(() => _wallpapers = results);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(_categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppColors.bgDark,
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
            child: Text('Error: $e',
                style: const TextStyle(color: AppColors.textSecondary))),
        data: (categories) {
          if (_selectedCategoryId == null && categories.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadCategory(categories.first.id);
            });
          }
          return Row(
            children: [
              // Left sidebar: category list
              Container(
                width: 90,
                color: AppColors.bgDarkSurface,
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final selected = _selectedCategoryId == cat.id;
                    return GestureDetector(
                      onTap: () => _loadCategory(cat.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 6),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Right: wallpapers
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary))
                    : _wallpapers.isEmpty
                        ? Center(
                            child: Text('No wallpapers in this category',
                                style: const TextStyle(
                                    color: AppColors.textMuted)))
                        : GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: AppConstants.gridAspectRatio,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _wallpapers.length,
                            itemBuilder: (_, i) =>
                                WallpaperCard(wallpaper: _wallpapers[i]),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
