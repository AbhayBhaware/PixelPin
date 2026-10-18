import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelpin/features/splash/presentation/splash_screen.dart';
import 'package:pixelpin/features/home/presentation/screens/home_screen.dart';
import 'package:pixelpin/features/explore/presentation/screens/explore_screen.dart';
import 'package:pixelpin/features/search/presentation/screens/search_screen.dart';
import 'package:pixelpin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pixelpin/features/wallpaper_detail/presentation/screens/wallpaper_detail_screen.dart';
import 'package:pixelpin/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:pixelpin/features/settings/presentation/screens/settings_screen.dart';
import 'package:pixelpin/shared/widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                name: 'explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/wallpaper/:id',
        name: 'wallpaperDetail',
        builder: (context, state) {
          final wallpaperId = state.pathParameters['id']!;
          return WallpaperDetailScreen(wallpaperId: wallpaperId);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
