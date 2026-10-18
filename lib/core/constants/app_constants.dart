class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Wall My Paper';
  static const String appShortName = 'WMP';
  static const String appTagline = 'Your screen, your story.';
  static const String appVersion = '1.0.0';
  static const String appPackage = 'com.wallmypaper.app';

  // Firestore Collections
  static const String wallpapersCollection = 'wallpapers';
  static const String usersCollection = 'users';
  static const String categoriesCollection = 'categories';
  static const String featuredCollection = 'featured';
  static const String dailyStatsCollection = 'dailyStats';
  static const String earningsCollection = 'earnings';
  static const String payoutsCollection = 'payouts';
  static const String reportsCollection = 'reports';

  // Wallpaper Status
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  // User Roles (Custom Claims)
  static const String roleAdmin = 'admin';
  static const String roleContributor = 'contributor';

  // Cloudinary
  static const String cloudinaryBaseUrl = 'https://res.cloudinary.com';
  static const String cloudinaryCloudName = 'YOUR_CLOUD_NAME'; // Replace with env
  static const int thumbWidth = 400;
  static const int previewWidth = 1080;

  // Pagination
  static const int wallpapersPageSize = 20;
  static const int categoriesPageSize = 50;

  // Revenue Split
  static const double platformCutPercent = 0.30; // 30% platform cut
  static const double contributorPoolPercent = 0.70; // 70% to contributors

  // Engagement Score Weights
  static const int viewWeight = 1;
  static const int downloadWeight = 5;
  static const int shareWeight = 3;

  // Minimum Wallpaper Resolution (4K on long side)
  static const int minWidth = 2160;
  static const int minHeight = 3840;

  // Local Storage Keys
  static const String favoritesKey = 'local_favorites';
  static const String onboardingKey = 'onboarding_complete';
  static const String themeKey = 'app_theme';

  // AdMob Test IDs (replace with real IDs before release)
  static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';

  // Timing
  static const Duration viewDebounce = Duration(seconds: 5);
  static const Duration splashDuration = Duration(seconds: 3);

  // Grid Settings
  static const int gridCrossAxisCount = 2;
  static const double gridAspectRatio = 0.56; // Portrait wallpapers
  static const double gridSpacing = 8.0;
}
