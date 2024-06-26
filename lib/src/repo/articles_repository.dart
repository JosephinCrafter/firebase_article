part of '../../firebase_article.dart';

/// The repository setup will look like this:
/// /articles
///         ./setup
///         ./some_article
///                     ./some_article_docs

/// Firestore instance to be used.

class ArticlesRepository<T extends Article> {
  /// The repository of articles.
  ///
  /// [collection] is the string name of the collection in firestore.
  /// To open projects, simply change [collection] to [projectsCollection]
  /// and so on.
  ArticlesRepository({
    this.collection = articlesCollection,
    required this.firestoreInstance,
  });

  Map<String, T?> memoryCachedArticles = {};

  /// Name of Setup Document.
  ///
  /// Setup Document contain the article management setup like
  /// highlighted article, list of all articles and more.
  ///
  /// It is loaded to have all article at glance and setup env.
  static const String setUpDoc = 'setup';

  /// The firestoreInstance to be used.
  FirebaseFirestore firestoreInstance;

  /// The String name of the Firebase collection to be used.
  final String collection;

  @Deprecated("""Since name doesn't relate to a property of an article, this method 
              has changed to [getArticleById]""")
  Future<T?> getArticleByName({required String articleName}) async {
    return getArticleById(articleId: articleName);
  }

  /// Return a fully formed article given it's articleTitle
  Future<T?> getArticleById({required String articleId}) async {
    // If [articleTitle] is a [memoryCachedArticles], then return the article in it
    T? articleInMemory = memoryCachedArticles[articleId];
    if (articleInMemory != null) {
      return articleInMemory;
    }

    // else, get the article from firebase.
    DocumentSnapshot<Map<String, dynamic>> result =
        await getRawDoc(articleId);
    Map<String, dynamic>? map = result.data();
    if (map == null) {
      return null;
    }

    // build [articleInMemory] from the firebase result.
    articleInMemory = buildArticleFromDoc(map);

    // add it to memoryCachedArticles
    memoryCachedArticles.addAll({articleId: articleInMemory});

    return articleInMemory;
  }

  @Deprecated("Use getHighlighted instead")
  Future<T?> getArticleOfTheMonth() async {
    return getHighlighted();
  }

  /// Get the highlighted article.
  Future<T?> getHighlighted() async {
    // First, read setup to get the document name of the currently highlighted
    // article.
    final String highlightedArticleDoc = await setUp.then<String>(
      (value) {
        if (value == null) {
          throw UnableToGetSetup(
              '[FirebaseArticlesRepository]: Error getting Setup: setup object is $value');
        }
        return value[RepoSetUp.highLight] as String;
      },
    );

    return await getArticleById(articleId: highlightedArticleDoc);
  }

  /// return a map string object containing setup
  Future<Map<String, dynamic>?> get setUp async {
    Map<String, dynamic>? setup;
    try {
      setup = await getRawDoc(setUpDoc).then<Map<String, dynamic>?>(
        (value) => value.data(),
      );
      if (setup == null) {
        var error = UnableToGetSetup('Setup is null.');
        developer.log('Error getting setup: $error');
        throw error;
      }
      return setup;
    } catch (e) {
      developer.log('[Firebase_article]: Unable to get setup: $e');
    }
    return null;
  }

  /// A shortcut for firestoreInstance.doc() function
  Future<DocumentSnapshot<Map<String, dynamic>>> getRawDoc(String path) async {
    return await firestoreInstance
        .doc(
          '$collection/$path',
        )
        .get();
  }

  Future<List<T?>?> getArticlesSubListByLength(int length) async {
    try {
      // Getting setup
      Map<String, dynamic>? setup = await setUp;

      //  end execution  when setup is empty
      if (setup != null) {
        // Building selected Titles
        List<String> articleIds =
            (setup[RepoSetUp.ids] as List<dynamic>).cast<String>();
        List<String>? selectedIds = [];

        int minimum = min(length, articleIds.length);

        for (int i = 0; i < minimum; i++) {
          selectedIds.add(
            articleIds.elementAt(i),
          );
        }

        // filling articles with article
        // filling articles with article
        return await _getArticleFromList(selectedIds);
      }
    } on UnableToGetSetup catch (e) {
      developer.log('Error getting setup: $e');
      rethrow;
    } catch (e) {
      developer.log('Error getting articles: $e');
    }
    return null;
  }

  Future<List<T>?> getArticlesSubListByIds(List<String> ids) async {
    try {
      // Getting setup
      Map<String, dynamic>? setup = await setUp;

      // end execution when setup is empty
      if (setup == null) {
        var error = UnableToGetSetup('Setup is null.');
        developer.log('[Firebase_article]: Error getting setup: $error');
        throw error;
      } else {
        // Building selected Titles
        List<String> allIds =
            (setup[RepoSetUp.ids] as List<dynamic>).cast<String>();
        List<String>? selectedIds = [];

        // int minimum = min(length, articleTitles.length);

        ids.forEach(
          (element) {
            if (allIds.contains(element)) {
              selectedIds.add(element);
            }
          },
        );

        // filling articles with article
        return await _getArticleFromList(selectedIds);
      }
    } on UnableToGetSetup catch (e) {
      developer.log('Error getting setup: $e');
      rethrow;
    } catch (e) {
      developer.log('Error getting articles: $e');
    }
    return null;
  }

  Future<List<T>?> _getArticleFromList(List<String> selectedIds) async {
    List<T>? articles = [];
    for (String articleTitle in selectedIds) {
      T? article = await getArticleById(
        articleId: articleTitle,
      );
      if (article != null) {
        articles.add(article);
      }
    }

    return articles;
  }

  /// Rebuild article from a doc.result
  T? buildArticleFromDoc(Map<String, dynamic> map) {
    return Article.fromDoc(map) as T;
  }
}

/// A class containing repo settings
class RepoSetUp {
  /// highlighted article key
  static const String highLight = 'highLight';

  /// All articles key: 'articles'.
  ///
  /// The value of this key is a [List<String>]
  static const String ids = 'articles';

  /// Cover image key
  static const String coverImageKey = 'cover_image';

  /// preview
  static const String previewKey = 'preview';
}

/// Raised when firestore doesn't contain any valid setupDocument
class UnableToGetSetup extends Error {
  String? message;

  @pragma("vm:entry-point")
  UnableToGetSetup(this.message);

  @override
  String toString() => 'Unable to get Setup: $message';
}

abstract class Docable {
  Docable.fromDoc(Map map);
}
