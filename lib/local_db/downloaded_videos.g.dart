// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_videos.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDownloadedVideosCollection on Isar {
  IsarCollection<int, DownloadedVideos> get downloadedVideos =>
      this.collection();
}

final DownloadedVideosSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'DownloadedVideos',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'filePath', type: IsarType.string),
      IsarPropertySchema(name: 'title', type: IsarType.string),
      IsarPropertySchema(name: 'thumbnailUrl', type: IsarType.string),
      IsarPropertySchema(name: 'videoUrl', type: IsarType.string),
      IsarPropertySchema(name: 'author', type: IsarType.string),
      IsarPropertySchema(name: 'videoId', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, DownloadedVideos>(
    serialize: serializeDownloadedVideos,
    deserialize: deserializeDownloadedVideos,
    deserializeProperty: deserializeDownloadedVideosProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeDownloadedVideos(IsarWriter writer, DownloadedVideos object) {
  IsarCore.writeString(writer, 1, object.filePath);
  IsarCore.writeString(writer, 2, object.title);
  IsarCore.writeString(writer, 3, object.thumbnailUrl);
  IsarCore.writeString(writer, 4, object.videoUrl);
  IsarCore.writeString(writer, 5, object.author);
  IsarCore.writeString(writer, 6, object.videoId);
  return object.id;
}

@isarProtected
DownloadedVideos deserializeDownloadedVideos(IsarReader reader) {
  final int _id;
  _id = IsarCore.readId(reader);
  final String _filePath;
  _filePath = IsarCore.readString(reader, 1) ?? '';
  final String _title;
  _title = IsarCore.readString(reader, 2) ?? '';
  final String _thumbnailUrl;
  _thumbnailUrl = IsarCore.readString(reader, 3) ?? '';
  final String _videoUrl;
  _videoUrl = IsarCore.readString(reader, 4) ?? '';
  final String _author;
  _author = IsarCore.readString(reader, 5) ?? '';
  final String _videoId;
  _videoId = IsarCore.readString(reader, 6) ?? '';
  final object = DownloadedVideos(
    id: _id,
    filePath: _filePath,
    title: _title,
    thumbnailUrl: _thumbnailUrl,
    videoUrl: _videoUrl,
    author: _author,
    videoId: _videoId,
  );
  return object;
}

@isarProtected
dynamic deserializeDownloadedVideosProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DownloadedVideosUpdate {
  bool call({
    required int id,
    String? filePath,
    String? title,
    String? thumbnailUrl,
    String? videoUrl,
    String? author,
    String? videoId,
  });
}

class _DownloadedVideosUpdateImpl implements _DownloadedVideosUpdate {
  const _DownloadedVideosUpdateImpl(this.collection);

  final IsarCollection<int, DownloadedVideos> collection;

  @override
  bool call({
    required int id,
    Object? filePath = ignore,
    Object? title = ignore,
    Object? thumbnailUrl = ignore,
    Object? videoUrl = ignore,
    Object? author = ignore,
    Object? videoId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (filePath != ignore) 1: filePath as String?,
            if (title != ignore) 2: title as String?,
            if (thumbnailUrl != ignore) 3: thumbnailUrl as String?,
            if (videoUrl != ignore) 4: videoUrl as String?,
            if (author != ignore) 5: author as String?,
            if (videoId != ignore) 6: videoId as String?,
          },
        ) >
        0;
  }
}

sealed class _DownloadedVideosUpdateAll {
  int call({
    required List<int> id,
    String? filePath,
    String? title,
    String? thumbnailUrl,
    String? videoUrl,
    String? author,
    String? videoId,
  });
}

class _DownloadedVideosUpdateAllImpl implements _DownloadedVideosUpdateAll {
  const _DownloadedVideosUpdateAllImpl(this.collection);

  final IsarCollection<int, DownloadedVideos> collection;

  @override
  int call({
    required List<int> id,
    Object? filePath = ignore,
    Object? title = ignore,
    Object? thumbnailUrl = ignore,
    Object? videoUrl = ignore,
    Object? author = ignore,
    Object? videoId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (filePath != ignore) 1: filePath as String?,
      if (title != ignore) 2: title as String?,
      if (thumbnailUrl != ignore) 3: thumbnailUrl as String?,
      if (videoUrl != ignore) 4: videoUrl as String?,
      if (author != ignore) 5: author as String?,
      if (videoId != ignore) 6: videoId as String?,
    });
  }
}

extension DownloadedVideosUpdate on IsarCollection<int, DownloadedVideos> {
  _DownloadedVideosUpdate get update => _DownloadedVideosUpdateImpl(this);

  _DownloadedVideosUpdateAll get updateAll =>
      _DownloadedVideosUpdateAllImpl(this);
}

sealed class _DownloadedVideosQueryUpdate {
  int call({
    String? filePath,
    String? title,
    String? thumbnailUrl,
    String? videoUrl,
    String? author,
    String? videoId,
  });
}

class _DownloadedVideosQueryUpdateImpl implements _DownloadedVideosQueryUpdate {
  const _DownloadedVideosQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<DownloadedVideos> query;
  final int? limit;

  @override
  int call({
    Object? filePath = ignore,
    Object? title = ignore,
    Object? thumbnailUrl = ignore,
    Object? videoUrl = ignore,
    Object? author = ignore,
    Object? videoId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (filePath != ignore) 1: filePath as String?,
      if (title != ignore) 2: title as String?,
      if (thumbnailUrl != ignore) 3: thumbnailUrl as String?,
      if (videoUrl != ignore) 4: videoUrl as String?,
      if (author != ignore) 5: author as String?,
      if (videoId != ignore) 6: videoId as String?,
    });
  }
}

extension DownloadedVideosQueryUpdate on IsarQuery<DownloadedVideos> {
  _DownloadedVideosQueryUpdate get updateFirst =>
      _DownloadedVideosQueryUpdateImpl(this, limit: 1);

  _DownloadedVideosQueryUpdate get updateAll =>
      _DownloadedVideosQueryUpdateImpl(this);
}

class _DownloadedVideosQueryBuilderUpdateImpl
    implements _DownloadedVideosQueryUpdate {
  const _DownloadedVideosQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<DownloadedVideos, DownloadedVideos, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? filePath = ignore,
    Object? title = ignore,
    Object? thumbnailUrl = ignore,
    Object? videoUrl = ignore,
    Object? author = ignore,
    Object? videoId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (filePath != ignore) 1: filePath as String?,
        if (title != ignore) 2: title as String?,
        if (thumbnailUrl != ignore) 3: thumbnailUrl as String?,
        if (videoUrl != ignore) 4: videoUrl as String?,
        if (author != ignore) 5: author as String?,
        if (videoId != ignore) 6: videoId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension DownloadedVideosQueryBuilderUpdate
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QOperations> {
  _DownloadedVideosQueryUpdate get updateFirst =>
      _DownloadedVideosQueryBuilderUpdateImpl(this, limit: 1);

  _DownloadedVideosQueryUpdate get updateAll =>
      _DownloadedVideosQueryBuilderUpdateImpl(this);
}

extension DownloadedVideosQueryFilter
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QFilterCondition> {
  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  thumbnailUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterFilterCondition>
  videoIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }
}

extension DownloadedVideosQueryObject
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QFilterCondition> {}

extension DownloadedVideosQuerySortBy
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QSortBy> {
  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByFilePathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> sortByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByThumbnailUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByThumbnailUrlDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByVideoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByVideoUrlDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> sortByAuthor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByAuthorDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> sortByVideoId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  sortByVideoIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedVideosQuerySortThenBy
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QSortThenBy> {
  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByFilePathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> thenByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByThumbnailUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByThumbnailUrlDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByVideoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByVideoUrlDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> thenByAuthor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByAuthorDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy> thenByVideoId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterSortBy>
  thenByVideoIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedVideosQueryWhereDistinct
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QDistinct> {
  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterDistinct>
  distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterDistinct>
  distinctByThumbnailUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterDistinct>
  distinctByVideoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterDistinct>
  distinctByAuthor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedVideos, DownloadedVideos, QAfterDistinct>
  distinctByVideoId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }
}

extension DownloadedVideosQueryProperty1
    on QueryBuilder<DownloadedVideos, DownloadedVideos, QProperty> {
  QueryBuilder<DownloadedVideos, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DownloadedVideos, String, QAfterProperty> filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DownloadedVideos, String, QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DownloadedVideos, String, QAfterProperty>
  thumbnailUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DownloadedVideos, String, QAfterProperty> videoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DownloadedVideos, String, QAfterProperty> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DownloadedVideos, String, QAfterProperty> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }
}

extension DownloadedVideosQueryProperty2<R>
    on QueryBuilder<DownloadedVideos, R, QAfterProperty> {
  QueryBuilder<DownloadedVideos, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DownloadedVideos, (R, String), QAfterProperty>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DownloadedVideos, (R, String), QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DownloadedVideos, (R, String), QAfterProperty>
  thumbnailUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DownloadedVideos, (R, String), QAfterProperty>
  videoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DownloadedVideos, (R, String), QAfterProperty> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DownloadedVideos, (R, String), QAfterProperty>
  videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }
}

extension DownloadedVideosQueryProperty3<R1, R2>
    on QueryBuilder<DownloadedVideos, (R1, R2), QAfterProperty> {
  QueryBuilder<DownloadedVideos, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DownloadedVideos, (R1, R2, String), QOperations>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DownloadedVideos, (R1, R2, String), QOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DownloadedVideos, (R1, R2, String), QOperations>
  thumbnailUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DownloadedVideos, (R1, R2, String), QOperations>
  videoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DownloadedVideos, (R1, R2, String), QOperations>
  authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DownloadedVideos, (R1, R2, String), QOperations>
  videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }
}
