// // todo: prevent adding id to prevent article conflict.
part of '../../firebase_article.dart';

/// Attribute of an Article
const String titleKey = 'title';
const String releaseDateKey = 'releaseDate';
const String contentKey = 'content';
const String relationsKey = 'relations';
const String idKey = 'id';

class Article {
  const Article({
    required this.id,
    this.title,
    this.releaseDate, // The date of the edition of this code
    this.contentPath,
    this.relations,
  });

  /// Build an Article from doc.
  /// These properties can all be null
  Article.fromDoc(Map<String, dynamic> doc)
      : id = doc[idKey],
        title = doc[titleKey],
        releaseDate = doc[releaseDateKey],
        contentPath = doc[contentKey],
        relations = doc[relationsKey];

  /// An unique way to specify an article or data
  final String id;

  /// Article title
  ///
  /// This variable should be the same as the article document name in
  /// cloud firestore. It is used to reference the article every where.
  final String? title;

  /// A string representing the release date of an article.
  ///
  /// Supported formatting is Fr,fr date format.
  /// ex: 19/01/2027
  final String? releaseDate;

  /// This is the Cloud Storage path that leads to the markdown file of the
  /// article.
  final String? contentPath;

  /// Related to the articles in a list of Maps.
  ///
  /// This can contains:
  /// - other articles
  /// - images
  /// - videos
  final List<Map<String, dynamic>>? relations;

  /// Create doc from an Article
  Map<String, dynamic> toDoc() => {
        idKey: id,
        titleKey: title,
        contentKey: contentPath,
        releaseDateKey: releaseDate,
        relationsKey: relations,
      };

  @override
  String toString() => '''
{
  $idKey: $id,
  $titleKey : $title,
  $releaseDateKey: $releaseDate,
  $contentKey: $contentPath,
  $relationsKey: $relations,
}
''';
}
