import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pixelpin/core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.bgDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'General'),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'Dark',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          const SizedBox(height: 20),

          _SectionHeader(title: 'About'),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _openUrl('https://wallmypaper.app/privacy'),
          ),
          _SettingsTile(
            icon: Icons.article_outlined,
            title: 'Terms of Service',
            onTap: () => _openUrl('https://wallmypaper.app/terms'),
          ),
          _SettingsTile(
            icon: Icons.copyright_rounded,
            title: 'DMCA / Takedown',
            onTap: () => _openUrl('https://wallmypaper.app/dmca'),
          ),
          _SettingsTile(
            icon: Icons.mail_outline_rounded,
            title: 'Contact / Support',
            onTap: () => _openUrl('mailto:support@wallmypaper.app'),
          ),
          const SizedBox(height: 20),

          _SectionHeader(title: 'Contributor'),
          _SettingsTile(
            icon: Icons.upload_outlined,
            title: 'Become a Contributor',
            subtitle: 'Upload your wallpapers at wallmypaper.app',
            onTap: () => _openUrl('https://wallmypaper.app/become-creator'),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              'Made with ❤️ by Wall My Paper',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgDarkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 14)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12))
            : null,
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textMuted, size: 18),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
