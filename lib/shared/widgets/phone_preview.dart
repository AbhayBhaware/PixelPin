import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/shared/widgets/wmp_button.dart';

enum PreviewMode {
  lockScreen,
  homeScreen,
}

class PhonePreviewModal extends StatefulWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onApply;

  const PhonePreviewModal({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required String imageUrl,
    required String title,
    VoidCallback? onApply,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Phone Preview',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return PhonePreviewModal(
          imageUrl: imageUrl,
          title: title,
          onApply: onApply,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<PhonePreviewModal> createState() => _PhonePreviewModalState();
}

class _PhonePreviewModalState extends State<PhonePreviewModal> {
  PreviewMode _mode = PreviewMode.lockScreen;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr = DateFormat('hh:mm').format(now);
    final dateStr = DateFormat('EEEE, MMMM d').format(now);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top Controls Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
                    tooltip: 'Close',
                  ),
                  const Spacer(),
                  // Mode Segmented Pill
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ModeButton(
                          title: 'Lock Screen',
                          icon: Icons.lock_outline_rounded,
                          isSelected: _mode == PreviewMode.lockScreen,
                          onTap: () => setState(() => _mode = PreviewMode.lockScreen),
                        ),
                        _ModeButton(
                          title: 'Home Screen',
                          icon: Icons.grid_view_rounded,
                          isSelected: _mode == PreviewMode.homeScreen,
                          onTap: () => setState(() => _mode = PreviewMode.homeScreen),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balancing width
                ],
              ),
            ),

            // Phone mockup view
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: AspectRatio(
                    aspectRatio: 9 / 19.5, // Standard modern smartphone aspect ratio
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Wallpaper Image
                            CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.cover,
                            ),

                            // Subtle Dark Gradient for text readability
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.45),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.35),
                                  ],
                                  stops: const [0.0, 0.45, 1.0],
                                ),
                              ),
                            ),

                            // Dynamic Island / Camera Notch
                            Positioned(
                              top: 10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 90,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                            // Status Bar Icons (Time / Wifi / Battery)
                            Positioned(
                              top: 14,
                              left: 24,
                              right: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    timeStr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Row(
                                    children: [
                                      Icon(Icons.signal_cellular_alt_rounded, color: Colors.white, size: 13),
                                      SizedBox(width: 4),
                                      Icon(Icons.wifi_rounded, color: Colors.white, size: 13),
                                      SizedBox(width: 4),
                                      Icon(Icons.battery_full_rounded, color: Colors.white, size: 13),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Preview Mode Content
                            if (_mode == PreviewMode.lockScreen)
                              _buildLockScreenOverlay(timeStr, dateStr)
                            else
                              _buildHomeScreenOverlay(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: WMPButton(
                label: 'Use This Wallpaper',
                icon: Icons.wallpaper_rounded,
                isFullWidth: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onApply?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockScreenOverlay(String timeStr, String dateStr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 70),
          const Icon(Icons.lock_rounded, color: Colors.white70, size: 16),
          const SizedBox(height: 4),
          Text(
            dateStr,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.sora(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.w700,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          // Sample Notification Pill
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.landscape_rounded, color: Colors.white, size: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wall My Paper',
                            style: GoogleFonts.sora(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Looks stunning on your screen ✨',
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'now',
                      style: GoogleFonts.inter(
                        color: Colors.white54,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // Flashlight and Camera circles
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleActionButton(Icons.flashlight_on_rounded),
                _buildCircleActionButton(Icons.camera_alt_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreenOverlay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 70),
          // Google/Search Bar Mock
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Search...',
                      style: GoogleFonts.inter(color: Colors.white54, fontSize: 11),
                    ),
                    const Spacer(),
                    const Icon(Icons.mic_rounded, color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // App icons grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _MockAppIcon(name: 'Gallery', icon: Icons.photo_library_rounded, color: Color(0xFF4A90E2)),
                _MockAppIcon(name: 'Camera', icon: Icons.camera_alt_rounded, color: Color(0xFF6C7A89)),
                _MockAppIcon(name: 'Music', icon: Icons.music_note_rounded, color: Color(0xFFFF5252)),
                _MockAppIcon(name: 'WMP', icon: Icons.landscape_rounded, color: AppColors.primary),
                _MockAppIcon(name: 'Browser', icon: Icons.public_rounded, color: Color(0xFF48CFAD)),
                _MockAppIcon(name: 'Settings', icon: Icons.settings_rounded, color: Color(0xFF95A5A6)),
                _MockAppIcon(name: 'Mail', icon: Icons.mail_rounded, color: Color(0xFF5D9CEC)),
                _MockAppIcon(name: 'Files', icon: Icons.folder_rounded, color: Color(0xFFFFCE54)),
              ],
            ),
          ),
          // Dock at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MockAppIcon(name: '', icon: Icons.phone_rounded, color: Color(0xFF2ECC71), isDock: true),
                      _MockAppIcon(name: '', icon: Icons.message_rounded, color: Color(0xFF3498DB), isDock: true),
                      _MockAppIcon(name: '', icon: Icons.language_rounded, color: Color(0xFF9B59B6), isDock: true),
                      _MockAppIcon(name: '', icon: Icons.camera_alt_rounded, color: Color(0xFFE67E22), isDock: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.black87 : Colors.white70,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockAppIcon extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isDock;

  const _MockAppIcon({
    required this.name,
    required this.icon,
    required this.color,
    this.isDock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isDock ? 40 : 44,
          height: isDock ? 40 : 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: isDock ? 20 : 22),
          ),
        ),
        if (name.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              shadows: const [
                Shadow(color: Colors.black87, blurRadius: 4),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
