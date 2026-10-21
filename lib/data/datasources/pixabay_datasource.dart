import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelpin/data/models/wallpaper_model.dart';

final pixabayDatasourceProvider = Provider<PixabayDatasource>((ref) {
  return PixabayDatasource();
});

class PixabayDatasource {
  static const String _apiKey = '54162459-bd34f88ee97d289f173e44d57';
  static const String _baseUrl = 'https://pixabay.com/api/';

  final Dio _dio;

  PixabayDatasource([Dio? dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
              ),
            );

  /// Fetch trending wallpapers (popular high-resolution vertical walls)
  Future<List<WallpaperModel>> getTrending({
    int page = 1,
    int limit = 30,
    String? category,
  }) async {
    final query = (category != null && category.toLowerCase() != 'all')
        ? _buildCategoryQuery(category)
        : 'wallpaper phone background vertical';

    return _fetchWallpapers({
      'q': query,
      'order': 'popular',
      'page': page,
      'per_page': limit.clamp(3, 200),
    }, defaultCategory: category);
  }

  /// Fetch featured / editor choice wallpapers
  Future<List<WallpaperModel>> getFeatured({
    int page = 1,
    int limit = 30,
    String? category,
  }) async {
    final query = (category != null && category.toLowerCase() != 'all')
        ? _buildCategoryQuery(category)
        : 'wallpaper background minimal 4k';

    // First try editors_choice for the highest curation quality
    final editorsChoice = await _fetchWallpapers({
      'q': query,
      'editors_choice': 'true',
      'order': 'popular',
      'page': page,
      'per_page': limit.clamp(3, 200),
    }, defaultCategory: category);

    if (editorsChoice.isNotEmpty) return editorsChoice;

    // Fallback if editor's choice returns empty for specific query
    return getTrending(page: page, limit: limit, category: category);
  }

  /// Fetch newest vertical wallpapers
  Future<List<WallpaperModel>> getNew({
    int page = 1,
    int limit = 30,
    String? category,
  }) async {
    final query = (category != null && category.toLowerCase() != 'all')
        ? _buildCategoryQuery(category)
        : 'wallpaper vertical';

    return _fetchWallpapers({
      'q': query,
      'order': 'latest',
      'page': page,
      'per_page': limit.clamp(3, 200),
    }, defaultCategory: category);
  }

  /// Fetch wallpapers for a specific topic / category
  Future<List<WallpaperModel>> getByCategory(
    String category, {
    int page = 1,
    int limit = 30,
  }) async {
    final query = _buildCategoryQuery(category);
    return _fetchWallpapers({
      'q': query,
      'order': 'popular',
      'page': page,
      'per_page': limit.clamp(3, 200),
    }, defaultCategory: category);
  }

  /// Search wallpapers by text query
  Future<List<WallpaperModel>> search(
    String query, {
    int page = 1,
    int limit = 30,
  }) async {
    final cleanQuery = query.trim().isEmpty ? 'wallpaper' : '${query.trim()} wallpaper';
    return _fetchWallpapers({
      'q': cleanQuery,
      'order': 'popular',
      'page': page,
      'per_page': limit.clamp(3, 200),
    });
  }

  /// Fetch single wallpaper by Pixabay ID
  Future<WallpaperModel?> getById(String id) async {
    final rawId = id.replaceFirst('pixabay_', '');
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'key': _apiKey,
          'id': rawId,
        },
      );
      final hits = response.data['hits'] as List?;
      if (hits != null && hits.isNotEmpty) {
        return _mapHitToWallpaper(hits.first as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _buildCategoryQuery(String category) {
    switch (category.toLowerCase()) {
      case 'amoled':
      case 'dark':
        return 'amoled dark black wallpaper';
      case 'anime':
        return 'anime aesthetic wallpaper';
      case 'nature':
        return 'nature landscape wallpaper';
      case 'space':
        return 'space galaxy stars wallpaper';
      case 'cyberpunk':
        return 'cyberpunk neon city wallpaper';
      case 'abstract':
        return 'abstract 3d aesthetic wallpaper';
      case 'minimal':
        return 'minimalist aesthetic wallpaper';
      case 'cars':
        return 'supercar automobile wallpaper';
      default:
        return '$category wallpaper';
    }
  }

  Future<List<WallpaperModel>> _fetchWallpapers(
    Map<String, dynamic> params, {
    String? defaultCategory,
  }) async {
    try {
      final queryParams = {
        'key': _apiKey,
        'image_type': 'photo',
        'orientation': 'vertical',
        'safesearch': 'true',
        ...params,
      };

      final response = await _dio.get('', queryParameters: queryParams);
      final hits = response.data['hits'] as List? ?? [];

      return hits
          .map((hit) => _mapHitToWallpaper(
                hit as Map<String, dynamic>,
                defaultCategory,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  WallpaperModel _mapHitToWallpaper(
    Map<String, dynamic> hit, [
    String? defaultCategory,
  ]) {
    final rawTagsString = hit['tags'] as String? ?? '';
    final rawTags = rawTagsString
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Generate clean human-readable title from top tags
    String title = '';
    if (rawTags.isNotEmpty) {
      title = rawTags.take(3).map((t) {
        if (t.isEmpty) return '';
        return t[0].toUpperCase() + t.substring(1);
      }).join(' • ');
    }
    if (title.isEmpty) {
      title = 'Wallpaper #${hit['id']}';
    }

    final category = defaultCategory != null && defaultCategory.toLowerCase() != 'all'
        ? defaultCategory
        : (rawTags.isNotEmpty ? _detectCategory(rawTags) : 'Nature');

    final author = (hit['user'] as String? ?? 'Pixabay Artist').trim();

    return WallpaperModel(
      id: 'pixabay_${hit['id']}',
      title: title,
      description: 'Ultra high-definition wallpaper by $author on Pixabay',
      tags: rawTags,
      category: category,
      contributorId: 'pixabay_${hit['user_id'] ?? 0}',
      contributorName: author.isNotEmpty ? author : 'Pixabay Artist',
      cloudinaryPublicId: '',
      imageUrl: (hit['largeImageURL'] as String?) ??
          (hit['webformatURL'] as String?) ??
          '',
      thumbUrl: (hit['webformatURL'] as String?) ??
          (hit['previewURL'] as String?) ??
          '',
      width: (hit['imageWidth'] as num?)?.toInt() ?? 1080,
      height: (hit['imageHeight'] as num?)?.toInt() ?? 1920,
      size: (hit['imageSize'] as num?)?.toInt() ?? 2500000,
      status: 'approved',
      stats: WallpaperStats(
        views: (hit['views'] as num?)?.toInt() ?? 120,
        downloads: (hit['downloads'] as num?)?.toInt() ?? 85,
        shares: (hit['comments'] as num?)?.toInt() ?? 12,
        favorites: (hit['likes'] as num?)?.toInt() ?? 45,
      ),
      createdAt: DateTime.now(),
      publishedAt: DateTime.now(),
    );
  }

  String _detectCategory(List<String> tags) {
    final joined = tags.join(' ').toLowerCase();
    if (joined.contains('dark') || joined.contains('black') || joined.contains('amoled')) {
      return 'AMOLED';
    }
    if (joined.contains('anime') || joined.contains('manga') || joined.contains('cartoon')) {
      return 'Anime';
    }
    if (joined.contains('space') || joined.contains('galaxy') || joined.contains('planet') || joined.contains('star')) {
      return 'Space';
    }
    if (joined.contains('car') || joined.contains('auto') || joined.contains('vehicle')) {
      return 'Cars';
    }
    if (joined.contains('minimal') || joined.contains('simple')) {
      return 'Minimal';
    }
    if (joined.contains('city') || joined.contains('neon') || joined.contains('cyberpunk')) {
      return 'Cyberpunk';
    }
    if (joined.contains('abstract') || joined.contains('pattern') || joined.contains('3d')) {
      return 'Abstract';
    }
    return 'Nature';
  }
}
