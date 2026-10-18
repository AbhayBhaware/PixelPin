// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallpaper_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WallpaperModel _$WallpaperModelFromJson(Map<String, dynamic> json) {
  return _WallpaperModel.fromJson(json);
}

/// @nodoc
mixin _$WallpaperModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get contributorId => throw _privateConstructorUsedError;
  String get contributorName => throw _privateConstructorUsedError;
  String get cloudinaryPublicId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get thumbUrl => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get rejectReason => throw _privateConstructorUsedError;
  String get reviewedBy => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  WallpaperStats get stats => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this WallpaperModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WallpaperModelCopyWith<WallpaperModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WallpaperModelCopyWith<$Res> {
  factory $WallpaperModelCopyWith(
    WallpaperModel value,
    $Res Function(WallpaperModel) then,
  ) = _$WallpaperModelCopyWithImpl<$Res, WallpaperModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    List<String> tags,
    String category,
    String contributorId,
    String contributorName,
    String cloudinaryPublicId,
    String imageUrl,
    String thumbUrl,
    int width,
    int height,
    int size,
    String status,
    String rejectReason,
    String reviewedBy,
    DateTime? reviewedAt,
    WallpaperStats stats,
    DateTime createdAt,
    DateTime? publishedAt,
  });

  $WallpaperStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$WallpaperModelCopyWithImpl<$Res, $Val extends WallpaperModel>
    implements $WallpaperModelCopyWith<$Res> {
  _$WallpaperModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? tags = null,
    Object? category = null,
    Object? contributorId = null,
    Object? contributorName = null,
    Object? cloudinaryPublicId = null,
    Object? imageUrl = null,
    Object? thumbUrl = null,
    Object? width = null,
    Object? height = null,
    Object? size = null,
    Object? status = null,
    Object? rejectReason = null,
    Object? reviewedBy = null,
    Object? reviewedAt = freezed,
    Object? stats = null,
    Object? createdAt = null,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            contributorId: null == contributorId
                ? _value.contributorId
                : contributorId // ignore: cast_nullable_to_non_nullable
                      as String,
            contributorName: null == contributorName
                ? _value.contributorName
                : contributorName // ignore: cast_nullable_to_non_nullable
                      as String,
            cloudinaryPublicId: null == cloudinaryPublicId
                ? _value.cloudinaryPublicId
                : cloudinaryPublicId // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbUrl: null == thumbUrl
                ? _value.thumbUrl
                : thumbUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            width: null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int,
            height: null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            rejectReason: null == rejectReason
                ? _value.rejectReason
                : rejectReason // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewedBy: null == reviewedBy
                ? _value.reviewedBy
                : reviewedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewedAt: freezed == reviewedAt
                ? _value.reviewedAt
                : reviewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as WallpaperStats,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            publishedAt: freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WallpaperStatsCopyWith<$Res> get stats {
    return $WallpaperStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WallpaperModelImplCopyWith<$Res>
    implements $WallpaperModelCopyWith<$Res> {
  factory _$$WallpaperModelImplCopyWith(
    _$WallpaperModelImpl value,
    $Res Function(_$WallpaperModelImpl) then,
  ) = __$$WallpaperModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    List<String> tags,
    String category,
    String contributorId,
    String contributorName,
    String cloudinaryPublicId,
    String imageUrl,
    String thumbUrl,
    int width,
    int height,
    int size,
    String status,
    String rejectReason,
    String reviewedBy,
    DateTime? reviewedAt,
    WallpaperStats stats,
    DateTime createdAt,
    DateTime? publishedAt,
  });

  @override
  $WallpaperStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$WallpaperModelImplCopyWithImpl<$Res>
    extends _$WallpaperModelCopyWithImpl<$Res, _$WallpaperModelImpl>
    implements _$$WallpaperModelImplCopyWith<$Res> {
  __$$WallpaperModelImplCopyWithImpl(
    _$WallpaperModelImpl _value,
    $Res Function(_$WallpaperModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? tags = null,
    Object? category = null,
    Object? contributorId = null,
    Object? contributorName = null,
    Object? cloudinaryPublicId = null,
    Object? imageUrl = null,
    Object? thumbUrl = null,
    Object? width = null,
    Object? height = null,
    Object? size = null,
    Object? status = null,
    Object? rejectReason = null,
    Object? reviewedBy = null,
    Object? reviewedAt = freezed,
    Object? stats = null,
    Object? createdAt = null,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _$WallpaperModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        contributorId: null == contributorId
            ? _value.contributorId
            : contributorId // ignore: cast_nullable_to_non_nullable
                  as String,
        contributorName: null == contributorName
            ? _value.contributorName
            : contributorName // ignore: cast_nullable_to_non_nullable
                  as String,
        cloudinaryPublicId: null == cloudinaryPublicId
            ? _value.cloudinaryPublicId
            : cloudinaryPublicId // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbUrl: null == thumbUrl
            ? _value.thumbUrl
            : thumbUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        width: null == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int,
        height: null == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        rejectReason: null == rejectReason
            ? _value.rejectReason
            : rejectReason // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewedBy: null == reviewedBy
            ? _value.reviewedBy
            : reviewedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewedAt: freezed == reviewedAt
            ? _value.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as WallpaperStats,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        publishedAt: freezed == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WallpaperModelImpl implements _WallpaperModel {
  const _$WallpaperModelImpl({
    required this.id,
    required this.title,
    this.description = '',
    final List<String> tags = const [],
    required this.category,
    required this.contributorId,
    required this.contributorName,
    required this.cloudinaryPublicId,
    required this.imageUrl,
    required this.thumbUrl,
    required this.width,
    required this.height,
    required this.size,
    this.status = 'pending',
    this.rejectReason = '',
    this.reviewedBy = '',
    this.reviewedAt,
    this.stats = const WallpaperStats(),
    required this.createdAt,
    this.publishedAt,
  }) : _tags = tags;

  factory _$WallpaperModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WallpaperModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String category;
  @override
  final String contributorId;
  @override
  final String contributorName;
  @override
  final String cloudinaryPublicId;
  @override
  final String imageUrl;
  @override
  final String thumbUrl;
  @override
  final int width;
  @override
  final int height;
  @override
  final int size;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String rejectReason;
  @override
  @JsonKey()
  final String reviewedBy;
  @override
  final DateTime? reviewedAt;
  @override
  @JsonKey()
  final WallpaperStats stats;
  @override
  final DateTime createdAt;
  @override
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'WallpaperModel(id: $id, title: $title, description: $description, tags: $tags, category: $category, contributorId: $contributorId, contributorName: $contributorName, cloudinaryPublicId: $cloudinaryPublicId, imageUrl: $imageUrl, thumbUrl: $thumbUrl, width: $width, height: $height, size: $size, status: $status, rejectReason: $rejectReason, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, stats: $stats, createdAt: $createdAt, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WallpaperModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.contributorId, contributorId) ||
                other.contributorId == contributorId) &&
            (identical(other.contributorName, contributorName) ||
                other.contributorName == contributorName) &&
            (identical(other.cloudinaryPublicId, cloudinaryPublicId) ||
                other.cloudinaryPublicId == cloudinaryPublicId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectReason, rejectReason) ||
                other.rejectReason == rejectReason) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    const DeepCollectionEquality().hash(_tags),
    category,
    contributorId,
    contributorName,
    cloudinaryPublicId,
    imageUrl,
    thumbUrl,
    width,
    height,
    size,
    status,
    rejectReason,
    reviewedBy,
    reviewedAt,
    stats,
    createdAt,
    publishedAt,
  ]);

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WallpaperModelImplCopyWith<_$WallpaperModelImpl> get copyWith =>
      __$$WallpaperModelImplCopyWithImpl<_$WallpaperModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WallpaperModelImplToJson(this);
  }
}

abstract class _WallpaperModel implements WallpaperModel {
  const factory _WallpaperModel({
    required final String id,
    required final String title,
    final String description,
    final List<String> tags,
    required final String category,
    required final String contributorId,
    required final String contributorName,
    required final String cloudinaryPublicId,
    required final String imageUrl,
    required final String thumbUrl,
    required final int width,
    required final int height,
    required final int size,
    final String status,
    final String rejectReason,
    final String reviewedBy,
    final DateTime? reviewedAt,
    final WallpaperStats stats,
    required final DateTime createdAt,
    final DateTime? publishedAt,
  }) = _$WallpaperModelImpl;

  factory _WallpaperModel.fromJson(Map<String, dynamic> json) =
      _$WallpaperModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get tags;
  @override
  String get category;
  @override
  String get contributorId;
  @override
  String get contributorName;
  @override
  String get cloudinaryPublicId;
  @override
  String get imageUrl;
  @override
  String get thumbUrl;
  @override
  int get width;
  @override
  int get height;
  @override
  int get size;
  @override
  String get status;
  @override
  String get rejectReason;
  @override
  String get reviewedBy;
  @override
  DateTime? get reviewedAt;
  @override
  WallpaperStats get stats;
  @override
  DateTime get createdAt;
  @override
  DateTime? get publishedAt;

  /// Create a copy of WallpaperModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WallpaperModelImplCopyWith<_$WallpaperModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WallpaperStats _$WallpaperStatsFromJson(Map<String, dynamic> json) {
  return _WallpaperStats.fromJson(json);
}

/// @nodoc
mixin _$WallpaperStats {
  int get views => throw _privateConstructorUsedError;
  int get downloads => throw _privateConstructorUsedError;
  int get shares => throw _privateConstructorUsedError;
  int get favorites => throw _privateConstructorUsedError;

  /// Serializes this WallpaperStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WallpaperStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WallpaperStatsCopyWith<WallpaperStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WallpaperStatsCopyWith<$Res> {
  factory $WallpaperStatsCopyWith(
    WallpaperStats value,
    $Res Function(WallpaperStats) then,
  ) = _$WallpaperStatsCopyWithImpl<$Res, WallpaperStats>;
  @useResult
  $Res call({int views, int downloads, int shares, int favorites});
}

/// @nodoc
class _$WallpaperStatsCopyWithImpl<$Res, $Val extends WallpaperStats>
    implements $WallpaperStatsCopyWith<$Res> {
  _$WallpaperStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WallpaperStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? views = null,
    Object? downloads = null,
    Object? shares = null,
    Object? favorites = null,
  }) {
    return _then(
      _value.copyWith(
            views: null == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                      as int,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
            shares: null == shares
                ? _value.shares
                : shares // ignore: cast_nullable_to_non_nullable
                      as int,
            favorites: null == favorites
                ? _value.favorites
                : favorites // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WallpaperStatsImplCopyWith<$Res>
    implements $WallpaperStatsCopyWith<$Res> {
  factory _$$WallpaperStatsImplCopyWith(
    _$WallpaperStatsImpl value,
    $Res Function(_$WallpaperStatsImpl) then,
  ) = __$$WallpaperStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int views, int downloads, int shares, int favorites});
}

/// @nodoc
class __$$WallpaperStatsImplCopyWithImpl<$Res>
    extends _$WallpaperStatsCopyWithImpl<$Res, _$WallpaperStatsImpl>
    implements _$$WallpaperStatsImplCopyWith<$Res> {
  __$$WallpaperStatsImplCopyWithImpl(
    _$WallpaperStatsImpl _value,
    $Res Function(_$WallpaperStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WallpaperStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? views = null,
    Object? downloads = null,
    Object? shares = null,
    Object? favorites = null,
  }) {
    return _then(
      _$WallpaperStatsImpl(
        views: null == views
            ? _value.views
            : views // ignore: cast_nullable_to_non_nullable
                  as int,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
        shares: null == shares
            ? _value.shares
            : shares // ignore: cast_nullable_to_non_nullable
                  as int,
        favorites: null == favorites
            ? _value.favorites
            : favorites // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WallpaperStatsImpl extends _WallpaperStats {
  const _$WallpaperStatsImpl({
    this.views = 0,
    this.downloads = 0,
    this.shares = 0,
    this.favorites = 0,
  }) : super._();

  factory _$WallpaperStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WallpaperStatsImplFromJson(json);

  @override
  @JsonKey()
  final int views;
  @override
  @JsonKey()
  final int downloads;
  @override
  @JsonKey()
  final int shares;
  @override
  @JsonKey()
  final int favorites;

  @override
  String toString() {
    return 'WallpaperStats(views: $views, downloads: $downloads, shares: $shares, favorites: $favorites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WallpaperStatsImpl &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads) &&
            (identical(other.shares, shares) || other.shares == shares) &&
            (identical(other.favorites, favorites) ||
                other.favorites == favorites));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, views, downloads, shares, favorites);

  /// Create a copy of WallpaperStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WallpaperStatsImplCopyWith<_$WallpaperStatsImpl> get copyWith =>
      __$$WallpaperStatsImplCopyWithImpl<_$WallpaperStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WallpaperStatsImplToJson(this);
  }
}

abstract class _WallpaperStats extends WallpaperStats {
  const factory _WallpaperStats({
    final int views,
    final int downloads,
    final int shares,
    final int favorites,
  }) = _$WallpaperStatsImpl;
  const _WallpaperStats._() : super._();

  factory _WallpaperStats.fromJson(Map<String, dynamic> json) =
      _$WallpaperStatsImpl.fromJson;

  @override
  int get views;
  @override
  int get downloads;
  @override
  int get shares;
  @override
  int get favorites;

  /// Create a copy of WallpaperStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WallpaperStatsImplCopyWith<_$WallpaperStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
