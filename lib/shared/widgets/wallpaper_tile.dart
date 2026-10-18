import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';

class WallpaperTile extends StatefulWidget {
  final WallpaperModel wallpaper;
  final bool showStats;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onLongPress;

  const WallpaperTile({
    super.key,
    required this.wallpaper,
    this.showStats = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onLongPress,
  });

  @override
  State<WallpaperTile> createState() => _WallpaperTileState();
}

class _WallpaperTileState extends State<WallpaperTile> with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimController;
  late Animation<double> _heartScaleAnimation;
  bool _localFavorite = false;

  @override
  void initState() {
    super.initState();
    _localFavorite = widget.isFavorite;
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0).chain(CurveTween(curve: Curves.elasticIn)), weight: 50),
    ]).animate(_heartAnimController);
  }

  @override
  void didUpdateWidget(covariant WallpaperTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _localFavorite = widget.isFavorite;
    }
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _handleFavorite() {
    HapticFeedback.lightImpact();
    setState(() {
      _localFavorite = !_localFavorite;
    });
    _heartAnimController.forward(from: 0.0);
    widget.onFavoriteToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final wallpaper = widget.wallpaper;

    return AspectRatio(
      aspectRatio: wallpaper.aspectRatio.clamp(0.55, 1.3),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            'wallpaperDetail',
            pathParameters: {'id': wallpaper.id},
          );
        },
        onLongPress: widget.onLongPress != null
            ? () {
                HapticFeedback.mediumImpact();
                widget.onLongPress!();
              }
            : null,
        child: Hero(
          tag: 'wallpaper-${wallpaper.id}',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image with cached network image and blurhash/shimmer placeholder
                  CachedNetworkImage(
                    imageUrl: wallpaper.optimizedThumbUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: AppColors.surfaceDark,
                        highlightColor: AppColors.surfaceElevatedDark,
                        child: Container(color: AppColors.surfaceDark),
                      );
                    },
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceElevatedDark,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: AppColors.textMutedDark,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  // Top corner badges (4K / AMOLED / NEW)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildBadge(wallpaper),
                  ),

                  // Bottom subtle gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 70,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black87,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallpaper.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (widget.showStats) ...[
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 11),
                                      const SizedBox(width: 3),
                                      Text(
                                        _formatCount(wallpaper.stats.views),
                                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 10),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.download_rounded, color: Colors.white70, size: 11),
                                      const SizedBox(width: 3),
                                      Text(
                                        _formatCount(wallpaper.stats.downloads),
                                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Quick favorite heart button with spring micro-animation
                          GestureDetector(
                            onTap: _handleFavorite,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ScaleTransition(
                                scale: _heartScaleAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Icon(
                                    _localFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    color: _localFavorite ? AppColors.accent : Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(WallpaperModel wallpaper) {
    if (wallpaper.is4K) {
      return _BadgePill(
        label: '4K',
        color: AppColors.primary,
        icon: Icons.hd_rounded,
      );
    } else if (wallpaper.isAmoled) {
      return const _BadgePill(
        label: 'AMOLED',
        color: Color(0xFF0F0C20),
        textColor: AppColors.primary,
        icon: Icons.dark_mode_rounded,
      );
    } else if (wallpaper.isNew) {
      return const _BadgePill(
        label: 'NEW',
        color: AppColors.accent,
        icon: Icons.fiber_new_rounded,
      );
    }
    return const SizedBox.shrink();
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _BadgePill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  const _BadgePill({
    required this.label,
    required this.color,
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: GoogleFonts.sora(
              color: textColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
