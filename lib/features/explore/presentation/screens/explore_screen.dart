import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/shared/widgets/wallpaper_tile.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? _selectedCategory;
  Color? _selectedColor;

  final _categories = [
    {
      'name': 'AMOLED',
      'count': '240+ Walls',
      'gradient': [Color(0xFF1E1B4B), Color(0xFF0F172A)],
      'icon': Icons.dark_mode_rounded,
    },
    {
      'name': 'Anime',
      'count': '180+ Walls',
      'gradient': [Color(0xFFEC4899), Color(0xFF8B5CF6)],
      'icon': Icons.auto_awesome_rounded,
    },
    {
      'name': 'Nature',
      'count': '320+ Walls',
      'gradient': [Color(0xFF10B981), Color(0xFF059669)],
      'icon': Icons.forest_rounded,
    },
    {
      'name': 'Space',
      'count': '150+ Walls',
      'gradient': [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      'icon': Icons.public_rounded,
    },
    {
      'name': 'Cyberpunk',
      'count': '190+ Walls',
      'gradient': [Color(0xFFF43F5E), Color(0xFFA855F7)],
      'icon': Icons.electric_bolt_rounded,
    },
    {
      'name': 'Abstract',
      'count': '210+ Walls',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF6366F1)],
      'icon': Icons.bubble_chart_rounded,
    },
    {
      'name': 'Minimal',
      'count': '130+ Walls',
      'gradient': [Color(0xFF64748B), Color(0xFF334155)],
      'icon': Icons.circle_outlined,
    },
    {
      'name': 'Cars',
      'count': '110+ Walls',
      'gradient': [Color(0xFFEF4444), Color(0xFFB91C1C)],
      'icon': Icons.directions_car_rounded,
    },
  ];

  final _colorSwatches = [
    {'name': 'Pure Black', 'color': Color(0xFF000000)},
    {'name': 'Electric Violet', 'color': Color(0xFF7C5CFF)},
    {'name': 'Hot Pink', 'color': Color(0xFFFF4D8D)},
    {'name': 'Cyan Glow', 'color': Color(0xFF00F0FF)},
    {'name': 'Emerald', 'color': Color(0xFF2DD4A0)},
    {'name': 'Amber Gold', 'color': Color(0xFFFFB020)},
    {'name': 'Crimson', 'color': Color(0xFFFF5470)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = ref.read(wallpaperRepositoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        title: Text(
          _selectedCategory != null
              ? '$_selectedCategory Wallpapers'
              : 'Explore & Discover',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _selectedCategory = null),
              )
            : null,
      ),
      body: _selectedCategory != null
          ? _buildCategoryDetailView(repo)
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color Palette Discovery Row
                  Text(
                    'Color Search',
                    style: GoogleFonts.sora(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find wallpapers matching your device setup aesthetic',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colorSwatches.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final swatch = _colorSwatches[index];
                        final color = swatch['color'] as Color;
                        final isSelected = _selectedColor == color;

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedColor = isSelected ? null : color;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white24 : Colors.black12),
                                width: isSelected ? 3 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: isSelected ? 12 : 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.check_rounded, color: Colors.white, size: 20),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Categories Grid Header
                  Text(
                    'Browse Categories',
                    style: GoogleFonts.sora(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'High definition 4K packs hand-curated by topic',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2-Column Visual Category Cards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final gradientColors = cat['gradient'] as List<Color>;

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() => _selectedCategory = cat['name'] as String);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  cat['icon'] as IconData,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat['name'] as String,
                                    style: GoogleFonts.sora(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    cat['count'] as String,
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryDetailView(WallpaperRepository repo) {
    return FutureBuilder(
      future: repo.getByCategory(_selectedCategory!.toLowerCase()),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final wallpapers = snap.data ?? [];
        if (wallpapers.isEmpty) {
          return Center(
            child: Text(
              'No wallpapers found in $_selectedCategory yet',
              style: GoogleFonts.inter(color: AppColors.textSecondaryDark),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 9 / 16,
          ),
          itemCount: wallpapers.length,
          itemBuilder: (context, index) {
            return WallpaperTile(wallpaper: wallpapers[index]);
          },
        );
      },
    );
  }
}
