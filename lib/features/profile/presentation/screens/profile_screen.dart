import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/providers/auth_role_provider.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/shared/providers/favorites_provider.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/shared/widgets/wallpaper_tile.dart';
import 'package:pixelpin/shared/widgets/wmp_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authUser = ref.watch(authStateProvider).value;
    final isCreator = ref.watch(isCreatorProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final repo = ref.read(wallpaperRepositoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pushNamed('settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    // Avatar & User Header
                    Row(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: authUser?.photoURL != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(34),
                                    child: Image.network(
                                      authUser!.photoURL!,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person_rounded,
                                    size: 38,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    authUser?.displayName ?? 'Wallpaper Explorer',
                                    style: GoogleFonts.sora(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  if (isCreator) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.primary, width: 0.8),
                                      ),
                                      child: Text(
                                        'CREATOR',
                                        style: GoogleFonts.sora(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                authUser?.email ?? 'Free guest account • No login needed',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Stats Bar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Favorites', '${favoriteIds.length}', isDark),
                          Container(width: 1, height: 28, color: isDark ? Colors.white12 : Colors.black12),
                          _buildStatColumn('Downloads', '12', isDark),
                          Container(width: 1, height: 28, color: isDark ? Colors.white12 : Colors.black12),
                          _buildStatColumn('Quality', '4K Ultra', isDark),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Become a Creator OR Creator Studio Card
                    if (!isCreator)
                      _buildBecomeCreatorBanner(context)
                    else
                      _buildCreatorStudioBanner(context),
                  ],
                ),
              ),
            ),

            // Tab Bar for Favorites & Downloads
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarHeaderDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  labelStyle: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'Saved Favorites'),
                    Tab(text: 'Download History'),
                  ],
                ),
                backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Favorites Tab
            _buildFavoritesView(favoriteIds, repo),

            // Download History Tab
            _buildDownloadsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }

  Widget _buildBecomeCreatorBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.accent, size: 22),
              const SizedBox(width: 8),
              Text(
                'Are you a wallpaper artist?',
                style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Upload your 4K creations, build a loyal following, and earn 70% revenue share from wallpaper downloads.',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 12),
          WMPButton(
            label: 'Apply to Become a Creator →',
            onPressed: () {
              HapticFeedback.mediumImpact();
              context.push('/become-creator');
            },
            size: WMPButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorStudioBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.surfaceElevatedDark,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Creator Studio',
                style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 3),
              Text(
                'Manage uploads, review queue, and stats',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
              ),
            ],
          ),
          WMPButton(
            label: 'Open',
            icon: Icons.dashboard_rounded,
            onPressed: () => context.push('/creator/studio'),
            size: WMPButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesView(Set<String> favoriteIds, WallpaperRepository repo) {
    if (favoriteIds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_outline_rounded, color: Colors.white24, size: 48),
              const SizedBox(height: 12),
              Text('No favorites yet', style: GoogleFonts.sora(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Heart wallpapers to collect them here for quick access',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white38), textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<List<WallpaperModel>>(
      future: Future.wait(
        favoriteIds.map((id) => repo.getWallpaper(id)),
      ).then((list) => list.whereType<WallpaperModel>().toList()),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final wallpapers = snap.data!;
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
            return WallpaperTile(wallpaper: wallpapers[index], showStats: true);
          },
        );
      },
    );
  }

  Widget _buildDownloadsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.download_done_rounded, color: Colors.white24, size: 48),
            const SizedBox(height: 12),
            Text('Saved in High Res', style: GoogleFonts.sora(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 4),
            Text('Downloaded wallpapers are saved directly to your device Photos/Gallery app',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white38), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  const _TabBarHeaderDelegate(this.tabBar, {required this.backgroundColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarHeaderDelegate oldDelegate) {
    return false;
  }
}
