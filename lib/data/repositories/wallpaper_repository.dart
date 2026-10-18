import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';
import 'package:pixelpin/core/constants/app_constants.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final wallpaperRepositoryProvider = Provider<WallpaperRepository>(
  (ref) => WallpaperRepository(ref.read(firestoreProvider)),
);

class WallpaperRepository {
  final FirebaseFirestore _firestore;

  WallpaperRepository(this._firestore);

  CollectionReference get _col =>
      _firestore.collection(AppConstants.wallpapersCollection);

  /// ── Home ──────────────────────────────────────────────────────────────────

  /// Stream of featured wallpapers (approved only)
  Stream<List<WallpaperModel>> watchFeatured({int limit = 10}) {
    return _firestore
        .collection(AppConstants.featuredCollection)
        .orderBy('order')
        .limit(limit)
        .snapshots()
        .asyncMap((snap) async {
      final ids = snap.docs.map((d) => d['wallpaperId'] as String).toList();
      if (ids.isEmpty) return <WallpaperModel>[];
      final futures = ids.map((id) => _col.doc(id).get());
      final docs = await Future.wait(futures);
      return docs
          .where((d) => d.exists)
          .map((d) => WallpaperModel.fromFirestore(d))
          .where((w) => w.status == AppConstants.statusApproved)
          .toList();
    });
  }

  /// Stream of trending wallpapers (sorted by downloads desc)
  Stream<List<WallpaperModel>> watchTrending({int limit = 20}) {
    return _col
        .where('status', isEqualTo: AppConstants.statusApproved)
        .orderBy('stats.downloads', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => WallpaperModel.fromFirestore(d))
            .toList());
  }

  /// Stream of newest wallpapers
  Stream<List<WallpaperModel>> watchNew({int limit = 20}) {
    return _col
        .where('status', isEqualTo: AppConstants.statusApproved)
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => WallpaperModel.fromFirestore(d))
            .toList());
  }

  /// ── Category ──────────────────────────────────────────────────────────────

  Future<List<WallpaperModel>> getByCategory(
    String categoryId, {
    int limit = AppConstants.wallpapersPageSize,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = _col
        .where('status', isEqualTo: AppConstants.statusApproved)
        .where('category', isEqualTo: categoryId)
        .orderBy('publishedAt', descending: true)
        .limit(limit);

    if (lastDoc != null) query = query.startAfterDocument(lastDoc);

    final snap = await query.get();
    return snap.docs.map((d) => WallpaperModel.fromFirestore(d)).toList();
  }

  /// ── Search ────────────────────────────────────────────────────────────────

  Future<List<WallpaperModel>> search(
    String query, {
    int limit = AppConstants.wallpapersPageSize,
  }) async {
    final lower = query.toLowerCase();
    // Basic Firestore tag/title search (for full-text, upgrade to Algolia/Typesense)
    final snap = await _col
        .where('status', isEqualTo: AppConstants.statusApproved)
        .where('tags', arrayContains: lower)
        .limit(limit)
        .get();
    return snap.docs.map((d) => WallpaperModel.fromFirestore(d)).toList();
  }

  /// ── Single Wallpaper ──────────────────────────────────────────────────────

  Stream<WallpaperModel?> watchWallpaper(String id) {
    return _col.doc(id).snapshots().map((snap) {
      if (!snap.exists) return null;
      return WallpaperModel.fromFirestore(snap);
    });
  }

  Future<WallpaperModel?> getWallpaper(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return WallpaperModel.fromFirestore(doc);
  }

  /// ── Stats ─────────────────────────────────────────────────────────────────

  /// Increment a stat field (views/downloads/shares/favorites)
  /// Uses a Cloud Function in production; here it's a direct write
  Future<void> incrementStat(String wallpaperId, String field) async {
    await _col.doc(wallpaperId).update({
      'stats.$field': FieldValue.increment(1),
    });
  }
}
