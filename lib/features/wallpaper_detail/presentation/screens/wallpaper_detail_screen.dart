import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/data/repositories/wallpaper_repository.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/shared/providers/favorites_provider.dart';
import 'package:pixelpin/shared/widgets/phone_preview.dart';
import 'package:pixelpin/shared/widgets/wmp_button.dart';

class WallpaperDetailScreen extends ConsumerStatefulWidget {
  final String wallpaperId;
  const WallpaperDetailScreen({super.key, required this.wallpaperId});

  @override
  ConsumerState<WallpaperDetailScreen> createState() =>
      _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends ConsumerState<WallpaperDetailScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0;
  bool _showInfo = true;

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(wallpaperRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
          ),
        ),
        actions: [
          // Info Toggle
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => _showInfo = !_showInfo);
              },
              icon: Icon(
                _showInfo ? Icons.info_rounded : Icons.info_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<WallpaperModel?>(
        stream: repo.watchWallpaper(widget.wallpaperId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final wallpaper = snap.data;
          if (wallpaper == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image_rounded,
                      color: Colors.white54, size: 48),
                  const SizedBox(height: 12),
                  Text('Wallpaper not found',
                      style: GoogleFonts.sora(color: Colors.white, fontSize: 16)),
                ],
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // Interactive full-screen image with double-tap zoom
              GestureDetector(
                onTap: () => setState(() => _showInfo = !_showInfo),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 3.5,
                  child: Hero(
                    tag: 'wallpaper-${wallpaper.id}',
                    child: CachedNetworkImage(
                      imageUrl: wallpaper.optimizedPreviewUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CachedNetworkImage(
                        imageUrl: wallpaper.optimizedThumbUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Glass Action and Info Panel
              if (_showInfo)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _DetailBottomPanel(
                    wallpaper: wallpaper,
                    isDownloading: _isDownloading,
                    downloadProgress: _downloadProgress,
                    onDownloadTap: () => _showDownloadQualitySheet(wallpaper),
                    onPreviewTap: () => _openPhonePreview(wallpaper),
                    onShareTap: () => _share(wallpaper),
                    onFavoriteTap: () => _toggleFavorite(wallpaper.id),
                  ),
                ),

              // Top Download Progress indicator
              if (_isDownloading)
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _downloadProgress == 0 ? null : _downloadProgress,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 3,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _openPhonePreview(WallpaperModel wallpaper) {
    HapticFeedback.mediumImpact();
    PhonePreviewModal.show(
      context,
      imageUrl: wallpaper.optimizedPreviewUrl,
      title: wallpaper.title,
      onApply: () => _downloadFile(wallpaper.imageUrl, wallpaper),
    );
  }

  void _showDownloadQualitySheet(WallpaperModel wallpaper) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _QualityPickerSheet(
          wallpaper: wallpaper,
          onQualitySelected: (qualityUrl) {
            Navigator.of(context).pop();
            _downloadFile(qualityUrl, wallpaper);
          },
        );
      },
    );
  }

  Future<void> _downloadFile(String targetUrl, WallpaperModel wallpaper) async {
    if (_isDownloading) return;
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final dio = Dio();
      final tempDir = Directory.systemTemp;
      final path = '${tempDir.path}/wmp_${wallpaper.id}.jpg';

      await dio.download(
        targetUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );

      await Gal.putImage(path);
      HapticFeedback.heavyImpact();

      await ref
          .read(wallpaperRepositoryProvider)
          .incrementStat(wallpaper.id, 'downloads');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surfaceElevatedDark,
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Saved 4K wallpaper to your gallery!',
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.danger,
            content: Text('Download failed: $e', style: GoogleFonts.inter(color: Colors.white)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _share(WallpaperModel wallpaper) async {
    HapticFeedback.lightImpact();
    await Share.share(
      'Check out "${wallpaper.title}" on Wall My Paper!\nhttps://wallmypaper.app/w/${wallpaper.id}',
      subject: wallpaper.title,
    );
    await ref
        .read(wallpaperRepositoryProvider)
        .incrementStat(wallpaper.id, 'shares');
  }

  void _toggleFavorite(String id) {
    HapticFeedback.lightImpact();
    ref.read(favoritesProvider.notifier).toggle(id);
  }
}

class _DetailBottomPanel extends ConsumerWidget {
  final WallpaperModel wallpaper;
  final bool isDownloading;
  final double downloadProgress;
  final VoidCallback onDownloadTap;
  final VoidCallback onPreviewTap;
  final VoidCallback onShareTap;
  final VoidCallback onFavoriteTap;

  const _DetailBottomPanel({
    required this.wallpaper,
    required this.isDownloading,
    required this.downloadProgress,
    required this.onDownloadTap,
    required this.onPreviewTap,
    required this.onShareTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorited = favorites.contains(wallpaper.id);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and Creator
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallpaper.title,
                          style: GoogleFonts.sora(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'by ${wallpaper.contributorName}',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badges
                  if (wallpaper.is4K)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '4K UHD',
                        style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Metadata Pills
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _MetaPill(label: wallpaper.resolution, icon: Icons.aspect_ratio_rounded),
                  _MetaPill(label: wallpaper.formattedSize, icon: Icons.folder_open_rounded),
                  _MetaPill(label: wallpaper.category, icon: Icons.category_rounded),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons Row
              Row(
                children: [
                  // Primary Download Quality Button
                  Expanded(
                    flex: 3,
                    child: WMPButton(
                      label: isDownloading ? 'Downloading...' : 'Download 4K',
                      icon: Icons.download_rounded,
                      isLoading: isDownloading,
                      onPressed: isDownloading ? null : onDownloadTap,
                      size: WMPButtonSize.medium,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Phone Preview Button
                  _IconButtonCircle(
                    icon: Icons.phone_android_rounded,
                    tooltip: 'Phone Preview',
                    onTap: onPreviewTap,
                  ),
                  const SizedBox(width: 8),

                  // Share
                  _IconButtonCircle(
                    icon: Icons.share_rounded,
                    tooltip: 'Share',
                    onTap: onShareTap,
                  ),
                  const SizedBox(width: 8),

                  // Favorite
                  _IconButtonCircle(
                    icon: isFavorited
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: isFavorited ? AppColors.accent : Colors.white,
                    tooltip: 'Favorite',
                    onTap: onFavoriteTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QualityPickerSheet extends StatelessWidget {
  final WallpaperModel wallpaper;
  final ValueChanged<String> onQualitySelected;

  const _QualityPickerSheet({
    required this.wallpaper,
    required this.onQualitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'title': 'Original 4K Ultra HD',
        'resolution': '${wallpaper.width}×${wallpaper.height}',
        'size': wallpaper.formattedSize,
        'url': wallpaper.imageUrl,
        'badge': 'Best Quality',
      },
      {
        'title': 'Quad HD 2K',
        'resolution': '1440×2560',
        'size': '~2.4 MB',
        'url': wallpaper.imageUrl.replaceFirst('/upload/', '/upload/w_1440,q_auto/'),
        'badge': 'Fast',
      },
      {
        'title': 'Full HD 1080p',
        'resolution': '1080×1920',
        'size': '~1.2 MB',
        'url': wallpaper.imageUrl.replaceFirst('/upload/', '/upload/w_1080,q_auto/'),
        'badge': 'Data Saver',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose Download Quality',
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select the resolution tailored for your screen',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
          ),
          const SizedBox(height: 20),

          ...options.map((opt) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderDark, width: 1),
              ),
              child: ListTile(
                onTap: () => onQualitySelected(opt['url']!),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                title: Row(
                  children: [
                    Text(
                      opt['title']!,
                      style: GoogleFonts.sora(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        opt['badge']!,
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${opt['resolution']} • ${opt['size']}',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                ),
                trailing: const Icon(Icons.download_rounded, color: Colors.white70),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _IconButtonCircle({
    required this.icon,
    this.color = Colors.white,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.8),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
