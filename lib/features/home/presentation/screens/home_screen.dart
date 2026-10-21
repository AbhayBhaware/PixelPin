import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/shared/widgets/wallpaper_tile.dart';
import 'package:pixelpin/shared/widgets/wallpaper_card.dart';
import 'package:pixelpin/shared/widgets/wmp_chips.dart';
import 'package:pixelpin/shared/widgets/empty_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedSection = 0;
  final _sections = ['Trending', 'Featured', 'New'];

  int _selectedCategoryIndex = 0;
  final _categories = [
    'All',
    'AMOLED',
    'Nature',
    'Anime',
    'Abstract',
    'Minimal',
    'Space',
    'Cyberpunk',
    'Cars',
    'Dark',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = ref.read(wallpaperRepositoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar with WMP Logo and Quick Actions
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.landscape_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Wall My Paper',
                    style: GoogleFonts.sora(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      '4K',
                      style: GoogleFonts.sora(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.pushNamed('search');
                  },
                  icon: const Icon(Icons.search_rounded),
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  tooltip: 'Search wallpapers',
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.pushNamed('settings');
                  },
                  icon: const Icon(Icons.settings_outlined),
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  tooltip: 'Settings',
                ),
              ],
            ),

            // Feed Headline
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Walls worth looking at.',
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Curated high-res 4K & AMOLED wallpapers for your screen',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section Filter Tabs (Trending / Featured / New)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(
                  children: List.generate(_sections.length, (i) {
                    final selected = _selectedSection == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CategoryChip(
                        label: _sections[i],
                        isSelected: selected,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedSection = i);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Horizontal Category Pill Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategoryIndex == index;
                    return CategoryChip(
                      label: category,
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCategoryIndex = index);
                      },
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Staggered Masonry Wallpaper Grid
            _WallpaperMasonryGrid(
              key: ValueKey('$_selectedSection-$_selectedCategoryIndex'),
              stream: _selectedSection == 0
                  ? repo.watchTrending(
                      limit: 30,
                      category: _selectedCategoryIndex == 0 ? null : _categories[_selectedCategoryIndex],
                    )
                  : _selectedSection == 1
                      ? repo.watchFeatured(
                          limit: 30,
                          category: _selectedCategoryIndex == 0 ? null : _categories[_selectedCategoryIndex],
                        )
                      : repo.watchNew(
                          limit: 30,
                          category: _selectedCategoryIndex == 0 ? null : _categories[_selectedCategoryIndex],
                        ),
            ),

            // Bottom Spacing for Floating Glass Nav Bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _WallpaperMasonryGrid extends StatelessWidget {
  final Stream<List<WallpaperModel>> stream;
  const _WallpaperMasonryGrid({required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WallpaperModel>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _buildSkeletonMasonryGrid();
        }

        if (snap.hasError) {
          return SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'Could Not Load Wallpapers',
              message: 'Check your internet connection and try refreshing.',
              buttonText: 'Retry',
              onButtonPressed: () {},
            ),
          );
        }

        final wallpapers = snap.data ?? [];
        if (wallpapers.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.image_not_supported_outlined,
              title: 'No Wallpapers Found',
              message: 'Check back soon for fresh 4K drops.',
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (context, index) {
              return WallpaperTile(
                wallpaper: wallpapers[index],
                showStats: true,
              );
            },
            childCount: wallpapers.length,
          ),
        );
      },
    );
  }

  Widget _buildSkeletonMasonryGrid() {
    final aspectRatios = [0.65, 0.58, 0.72, 0.62, 0.56, 0.70, 0.60, 0.68];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          return WallpaperCardSkeleton(
            aspectRatio: aspectRatios[index % aspectRatios.length],
          );
        },
        childCount: 8,
      ),
    );
  }
}
