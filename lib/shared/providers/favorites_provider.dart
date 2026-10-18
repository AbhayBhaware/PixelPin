import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixelpin/core/constants/app_constants.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AppConstants.favoritesKey) ?? [];
    state = Set<String>.from(list);
  }

  Future<void> toggle(String id) async {
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.favoritesKey, next.toList());
  }

  bool isFavorite(String id) => state.contains(id);
}
