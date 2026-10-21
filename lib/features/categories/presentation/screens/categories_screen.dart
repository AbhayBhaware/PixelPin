import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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

const _defaultCategories = [
  CategoryModel(id: 'amoled', name: 'AMOLED', icon: '🌑', order: 0),
  CategoryModel(id: 'nature', name: 'Nature', icon: '🌿', order: 1),
  CategoryModel(id: 'anime', name: 'Anime', icon: '⚡', order: 2),
  CategoryModel(id: 'space', name: 'Space', icon: '🌌', order: 3),
  CategoryModel(id: 'cyberpunk', name: 'Cyberpunk', icon: '🏙️', order: 4),
  CategoryModel(id: 'abstract', name: 'Abstract', icon: '🎨', order: 5),
  CategoryModel(id: 'minimal', name: 'Minimal', icon: '⚪', order: 6),
  CategoryModel(id: 'cars', name: 'Cars', icon: '🏎️', order: 7),
];

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(_categoriesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          'Categories',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textLightPrimary,
          ),
        ),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textLightPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => _buildBody(_defaultCategories, isDark),
        data: (categories) {
          final list = categories.isNotEmpty ? categories : _defaultCategories;
          return _buildBody(list, isDark);
        },
      ),
    );
  }

  Widget _buildBody(List<CategoryModel> categories, bool isDark) {
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCategory(categories.first.id);
      });
    }
    return Row(
      children: [
        // Left sidebar: category list
        Container(
          width: 92,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
            border: Border(
              right: BorderSide(
                color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
          ),
          child: ListView.builder(
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final selected = _selectedCategoryId == cat.id;
              return GestureDetector(
                onTap: () => _loadCategory(cat.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.transparent,
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
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textLightSecondary),
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
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
                  child: CircularProgressIndicator(color: AppColors.primary))
              : _wallpapers.isEmpty
                  ? Center(
                      child: Text(
                        'No wallpapers in this category',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textLightMuted,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: AppConstants.gridAspectRatio,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _wallpapers.length,
                      itemBuilder: (_, i) =>
                          WallpaperCard(wallpaper: _wallpapers[i]),
                    ),
        ),
      ],
    );
  }
}
