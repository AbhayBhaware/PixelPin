import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/shared/widgets/wallpaper_tile.dart';
import 'package:pixelpin/shared/widgets/wmp_chips.dart';
import 'package:pixelpin/shared/widgets/empty_state.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  List<WallpaperModel>? _results;
  bool _searching = false;
  String _lastQuery = '';

  // Filter state
  bool _only4K = false;
  bool _onlyAmoled = false;
  String? _selectedCategory;

  final _popularTags = [
    'AMOLED',
    'Anime',
    'Cyberpunk',
    'Nature',
    'Space',
    'Minimal',
    'Cars',
    'Dark',
    'Abstract',
    'Fantasy',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return;
    _lastQuery = cleanQuery;
    setState(() => _searching = true);

    try {
      final allResults = await ref
          .read(wallpaperRepositoryProvider)
          .search(cleanQuery);

      // Apply active filters client-side
      final filtered = allResults.where((w) {
        if (_only4K && !w.is4K) return false;
        if (_onlyAmoled && !w.isAmoled) return false;
        if (_selectedCategory != null &&
            w.category.toLowerCase() != _selectedCategory!.toLowerCase()) {
          return false;
        }
        return true;
      }).toList();

      if (mounted) setState(() => _results = filtered);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _openFiltersSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Filter Wallpapers',
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggles
                  SwitchListTile(
                    title: Text(
                      '4K Ultra HD Only',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: Text(
                      'Only display wallpapers 3840×2160 or higher',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                    value: _only4K,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setSheetState(() => _only4K = val);
                      setState(() {});
                      if (_lastQuery.isNotEmpty) _search(_lastQuery);
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      'AMOLED Pure Black',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: Text(
                      'High contrast true-black wallpapers',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                    value: _onlyAmoled,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setSheetState(() => _onlyAmoled = val);
                      setState(() {});
                      if (_lastQuery.isNotEmpty) _search(_lastQuery);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        title: Text(
          'Search Wallpapers',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.tune_rounded),
                if (_only4K || _onlyAmoled)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Filter search',
            onPressed: _openFiltersSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: _search,
                textInputAction: TextInputAction.search,
                style: GoogleFonts.inter(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by tag, color, style...',
                  hintStyle: GoogleFonts.inter(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            size: 18,
                          ),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _results = null);
                          },
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),

          // Search results or suggestions
          Expanded(
            child: _searching
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _results == null
                    ? _buildSuggestions(isDark)
                    : _results!.isEmpty
                        ? _buildEmptyState()
                        : _buildResultsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Searches',
            style: GoogleFonts.sora(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _popularTags.map((tag) {
              return TagChip(
                tag: tag,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _controller.text = tag;
                  _search(tag);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: 'No Wallpapers Found',
      message: 'We couldn\'t find anything for "$_lastQuery". Try browsing popular tags.',
      buttonText: 'Reset Search',
      onButtonPressed: () {
        _controller.clear();
        setState(() => _results = null);
      },
    );
  }

  Widget _buildResultsGrid() {
    return MasonryGridView.count(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: _results!.length,
      itemBuilder: (context, index) {
        return WallpaperTile(
          wallpaper: _results![index],
          showStats: true,
        );
      },
    );
  }
}
