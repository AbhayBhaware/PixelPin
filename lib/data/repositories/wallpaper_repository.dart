import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/core/constants/app_constants.dart';
import 'package:pixelpin/data/datasources/pixabay_datasource.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final wallpaperRepositoryProvider = Provider<WallpaperRepository>(
  (ref) => WallpaperRepository(
    ref.read(firestoreProvider),
    ref.read(pixabayDatasourceProvider),
  ),
);

class WallpaperRepository {
  final FirebaseFirestore _firestore;
  final PixabayDatasource _pixabay;

  // In-memory cache for all retrieved wallpapers (fast detail view & offline resilience)
  final Map<String, WallpaperModel> _cache = {};

  WallpaperRepository(this._firestore, this._pixabay);

  CollectionReference get _col =>
      _firestore.collection(AppConstants.wallpapersCollection);

  /// ── Home Feed ─────────────────────────────────────────────────────────────

  /// Stream of featured wallpapers (curated creator walls + Pixabay Editor's Choice)
  Stream<List<WallpaperModel>> watchFeatured({
    int limit = 30,
    String? category,
  }) async* {
    List<WallpaperModel> creatorWallpapers = [];

    try {
      final snap = await _firestore
          .collection(AppConstants.featuredCollection)
          .orderBy('order')
          .limit(limit)
          .get();

      final ids = snap.docs.map((d) => d['wallpaperId'] as String).toList();
      if (ids.isNotEmpty) {
        final futures = ids.map((id) => _col.doc(id).get());
        final docs = await Future.wait(futures);
        creatorWallpapers = docs
            .where((d) => d.exists)
            .map((d) => WallpaperModel.fromFirestore(d))
            .where((w) => w.status == AppConstants.statusApproved)
            .toList();
        for (final w in creatorWallpapers) {
          _cache[w.id] = w;
        }
      }
    } catch (_) {}

    // Fetch from Pixabay to supplement or fully supply the feed
    final remainingCount = (limit - creatorWallpapers.length).clamp(3, 100);
    final pixabayWalls = await _pixabay.getFeatured(
      limit: remainingCount,
      category: category,
    );

    for (final w in pixabayWalls) {
      _cache[w.id] = w;
    }

    final combined = [...creatorWallpapers, ...pixabayWalls];
    yield combined;
  }

  /// Stream of trending wallpapers (sorted by popularity/downloads)
  Stream<List<WallpaperModel>> watchTrending({
    int limit = 30,
    String? category,
  }) async* {
    List<WallpaperModel> creatorWallpapers = [];

    try {
      Query query = _col
          .where('status', isEqualTo: AppConstants.statusApproved)
          .orderBy('stats.downloads', descending: true);

      if (category != null && category.toLowerCase() != 'all') {
        query = query.where('category', isEqualTo: category);
      }

      final snap = await query.limit(limit).get();
      creatorWallpapers =
          snap.docs.map((d) => WallpaperModel.fromFirestore(d)).toList();

      for (final w in creatorWallpapers) {
        _cache[w.id] = w;
      }
    } catch (_) {}

    // Fetch Pixabay trending wallpapers
    final remainingCount = (limit - creatorWallpapers.length).clamp(3, 100);
    final pixabayWalls = await _pixabay.getTrending(
      limit: remainingCount,
      category: category,
    );

    for (final w in pixabayWalls) {
      _cache[w.id] = w;
    }

    final combined = [...creatorWallpapers, ...pixabayWalls];
    yield combined;
  }

  /// Stream of newest wallpapers
  Stream<List<WallpaperModel>> watchNew({
    int limit = 30,
    String? category,
  }) async* {
    List<WallpaperModel> creatorWallpapers = [];

    try {
      Query query = _col
          .where('status', isEqualTo: AppConstants.statusApproved)
          .orderBy('publishedAt', descending: true);

      if (category != null && category.toLowerCase() != 'all') {
        query = query.where('category', isEqualTo: category);
      }

      final snap = await query.limit(limit).get();
      creatorWallpapers =
          snap.docs.map((d) => WallpaperModel.fromFirestore(d)).toList();

      for (final w in creatorWallpapers) {
        _cache[w.id] = w;
      }
    } catch (_) {}

    final remainingCount = (limit - creatorWallpapers.length).clamp(3, 100);
    final pixabayWalls = await _pixabay.getNew(
      limit: remainingCount,
      category: category,
    );

    for (final w in pixabayWalls) {
      _cache[w.id] = w;
    }

    final combined = [...creatorWallpapers, ...pixabayWalls];
    yield combined;
  }

  /// ── Category Wallpapers ───────────────────────────────────────────────────

  Future<List<WallpaperModel>> getByCategory(
    String categoryId, {
    int limit = AppConstants.wallpapersPageSize,
    DocumentSnapshot? lastDoc,
  }) async {
    List<WallpaperModel> creatorWallpapers = [];

    try {
      Query query = _col
          .where('status', isEqualTo: AppConstants.statusApproved)
          .where('category', isEqualTo: categoryId)
          .orderBy('publishedAt', descending: true)
          .limit(limit);

      if (lastDoc != null) query = query.startAfterDocument(lastDoc);

      final snap = await query.get();
      creatorWallpapers =
          snap.docs.map((d) => WallpaperModel.fromFirestore(d)).toList();

      for (final w in creatorWallpapers) {
        _cache[w.id] = w;
      }
    } catch (_) {}

    final remainingCount = (limit - creatorWallpapers.length).clamp(3, 100);
    final pixabayWalls = await _pixabay.getByCategory(
      categoryId,
      limit: remainingCount,
    );

    for (final w in pixabayWalls) {
      _cache[w.id] = w;
    }

    return [...creatorWallpapers, ...pixabayWalls];
  }

  /// ── Search ────────────────────────────────────────────────────────────────

  Future<List<WallpaperModel>> search(
    String query, {
    int limit = AppConstants.wallpapersPageSize,
  }) async {
    final lower = query.toLowerCase().trim();
    List<WallpaperModel> creatorWallpapers = [];

    try {
      final snap = await _col
          .where('status', isEqualTo: AppConstants.statusApproved)
          .where('tags', arrayContains: lower)
          .limit(limit)
          .get();

      creatorWallpapers =
          snap.docs.map((d) => WallpaperModel.fromFirestore(d)).toList();

      for (final w in creatorWallpapers) {
        _cache[w.id] = w;
      }
    } catch (_) {}

    final remainingCount = (limit - creatorWallpapers.length).clamp(3, 100);
    final pixabayWalls = await _pixabay.search(
      query,
      limit: remainingCount,
    );

    for (final w in pixabayWalls) {
      _cache[w.id] = w;
    }

    return [...creatorWallpapers, ...pixabayWalls];
  }

  /// ── Single Wallpaper ──────────────────────────────────────────────────────

  Stream<WallpaperModel?> watchWallpaper(String id) {
    if (_cache.containsKey(id)) {
      return Stream.value(_cache[id]);
    }

    if (id.startsWith('pixabay_')) {
      return Stream.fromFuture(getWallpaper(id));
    }

    return _col.doc(id).snapshots().map((snap) {
      if (!snap.exists) return null;
      final model = WallpaperModel.fromFirestore(snap);
      _cache[model.id] = model;
      return model;
    });
  }

  Future<WallpaperModel?> getWallpaper(String id) async {
    if (_cache.containsKey(id)) {
      return _cache[id];
    }

    if (id.startsWith('pixabay_')) {
      final item = await _pixabay.getById(id);
      if (item != null) {
        _cache[item.id] = item;
      }
      return item;
    }

    try {
      final doc = await _col.doc(id).get();
      if (!doc.exists) return null;
      final model = WallpaperModel.fromFirestore(doc);
      _cache[model.id] = model;
      return model;
    } catch (_) {
      return null;
    }
  }

  /// ── Stats ─────────────────────────────────────────────────────────────────

  /// Increment a stat field (views/downloads/shares/favorites)
  Future<void> incrementStat(String wallpaperId, String field) async {
    // For Pixabay items, safely update local cache state
    if (wallpaperId.startsWith('pixabay_')) {
      final cached = _cache[wallpaperId];
      if (cached != null) {
        var stats = cached.stats;
        switch (field) {
          case 'downloads':
            stats = stats.copyWith(downloads: stats.downloads + 1);
            break;
          case 'views':
            stats = stats.copyWith(views: stats.views + 1);
            break;
          case 'shares':
            stats = stats.copyWith(shares: stats.shares + 1);
            break;
          case 'favorites':
            stats = stats.copyWith(favorites: stats.favorites + 1);
            break;
        }
        _cache[wallpaperId] = cached.copyWith(stats: stats);
      }
      return;
    }

    try {
      await _col.doc(wallpaperId).update({
        'stats.$field': FieldValue.increment(1),
      });
    } catch (_) {}
  }
}
