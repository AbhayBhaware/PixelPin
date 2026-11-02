import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/providers/auth_role_provider.dart';
import 'package:pixelpin/core/theme/app_colors.dart';
import 'package:pixelpin/shared/widgets/wmp_button.dart';

class BecomeCreatorScreen extends ConsumerStatefulWidget {
  const BecomeCreatorScreen({super.key});

  @override
  ConsumerState<BecomeCreatorScreen> createState() => _BecomeCreatorScreenState();
}

class _BecomeCreatorScreenState extends ConsumerState<BecomeCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _bioController = TextEditingController();

  String _selectedStyle = 'AMOLED & Minimal';
  bool _confirmedOriginal = false;
  bool _isSubmitting = false;

  final List<String> _artStyles = [
    'AMOLED & Minimal',
    'Cyberpunk & Neon',
    'Nature & Landscapes',
    'Anime & Illustration',
    'Space & Cosmic',
    'Abstract & 3D Fluid',
    'Supercars & Automotive',
    'Architecture & Urban',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).value;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      _nameController.text = user.displayName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portfolioController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    HapticFeedback.lightImpact();
    try {
      final authService = ref.read(authServiceProvider);
      final cred = await authService.signInWithGoogle();
      if (cred?.user?.displayName != null && _nameController.text.isEmpty) {
        setState(() {
          _nameController.text = cred!.user!.displayName!;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed in as ${cred?.user?.displayName ?? cred?.user?.email}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in cancelled or failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_confirmedOriginal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm that you hold rights to your artwork.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.submitCreatorApplication(
        displayName: _nameController.text,
        portfolioUrl: _portfolioController.text,
        bio: _bioController.text,
        artStyle: _selectedStyle,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully! Our curators will review it.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting application: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authUser = ref.watch(authStateProvider).value;
    final isCreator = ref.watch(isCreatorProvider);
    final applicationAsync = ref.watch(creatorApplicationProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Creator Program',
          style: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If already approved as creator
            if (isCreator) ...[
              _buildApprovedCreatorCard(context, isDark),
            ] else ...[
              // Check application status
              applicationAsync.when(
                data: (appData) {
                  final status = appData?['status'] as String?;
                  if (status == 'pending') {
                    return _buildPendingReviewCard(appData!, isDark);
                  } else if (status == 'rejected') {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRejectedCard(appData!, isDark),
                        const SizedBox(height: 24),
                        _buildApplicationForm(authUser, isDark),
                      ],
                    );
                  } else {
                    return _buildApplicationForm(authUser, isDark);
                  }
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (_, __) => _buildApplicationForm(authUser, isDark),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedCreatorCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Center(
              child: Icon(Icons.verified_rounded, color: AppColors.primary, size: 44),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You are an Approved Creator!',
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your wallpapers are published across PixelPin for thousands of daily users. Open Creator Studio to manage your uploads and track download analytics.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          WMPButton(
            label: 'Open Creator Studio →',
            isFullWidth: true,
            onPressed: () => context.push('/creator/studio'),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReviewCard(Map<String, dynamic> appData, bool isDark) {
    final style = appData['artStyle'] ?? 'Not specified';
    final portfolio = appData['portfolioUrl'] ?? 'None provided';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded, color: AppColors.warning, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application Under Review',
                      style: GoogleFonts.sora(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Submitted to PixelPin Admin Queue',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Thank you for applying! Our curation team reviews creator applications within 24 to 48 hours. Once approved, your account will instantly unlock Creator Studio privileges.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgDarkCard : AppColors.bgLightCard,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _buildInfoRow('Art Specialization', style, isDark),
                const Divider(height: 16),
                _buildInfoRow('Portfolio Link', portfolio, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedCard(Map<String, dynamic> appData, bool isDark) {
    final reason = appData['rejectionReason'] as String? ?? 'Portfolio did not meet current resolution criteria.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Needs Revision',
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You may update your details below and re-submit for review.',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm(dynamic authUser, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Colors.amberAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'PixelPin Creator Community',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Showcase your 4K wallpapers to thousands of mobile users worldwide.',
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildBenefitBadge('✓ 70% Revenue Share'),
                  const SizedBox(width: 8),
                  _buildBenefitBadge('✓ Verified Badge'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Auth Check
        if (authUser == null) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.account_circle_outlined, size: 48, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'Sign In with Google to Apply',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'We link your approved creator credentials directly to your Google account for secure authentication across app & web.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                WMPButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                  isFullWidth: true,
                  onPressed: _handleGoogleSignIn,
                ),
              ],
            ),
          ),
        ] else ...[
          // Application Form
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Creator Application Form',
                    style: GoogleFonts.sora(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Artist Name
                  _buildFieldLabel('Artist / Display Name *', isDark),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('e.g. StudioNeon or your name', isDark),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your artist name' : null,
                  ),
                  const SizedBox(height: 16),

                  // Portfolio URL
                  _buildFieldLabel('Portfolio or Social Art Link *', isDark),
                  TextFormField(
                    controller: _portfolioController,
                    decoration: _inputDecoration('Instagram, Behance, ArtStation, or Website link', isDark),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please provide a link to your artwork';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Art Specialization
                  _buildFieldLabel('Primary Art Style / Category', isDark),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStyle,
                    decoration: _inputDecoration('Select your style', isDark),
                    items: _artStyles.map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedStyle = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bio / Statement
                  _buildFieldLabel('Brief Bio / Artwork Description', isDark),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    decoration: _inputDecoration('Tell viewers and curators about your style...', isDark),
                  ),
                  const SizedBox(height: 16),

                  // Copyright confirmation
                  Row(
                    children: [
                      Checkbox(
                        value: _confirmedOriginal,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _confirmedOriginal = v ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'I confirm that all submissions are my original work or I hold full distribution licenses.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  WMPButton(
                    label: 'Submit Application for Review →',
                    isFullWidth: true,
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _submitApplication,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13,
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: isDark ? AppColors.bgDarkCard : AppColors.bgLightCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildBenefitBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
