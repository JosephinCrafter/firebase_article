import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_article/firebase_article.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  test(
    'Not trigger firebase transaction when article is in memoryCache',
    () async {
      FirebaseFirestore fakeFirestore = FakeFirebaseFirestore();

      fakeFirestore.doc('articles/test_article').set(
        {
          'id': 'test_article',
          'title': 'Test Article',
          'content': 'content.md',
          'releaseDate': '2024-05-30',
          'relations': [
            {
              'cover_image': "cover_image.jpg",
            },
          ],
        },
      );
      ArticlesRepository repo = ArticlesRepository(
        firestoreInstance: fakeFirestore,
      );

      Article? article =
          await repo.getArticleByName(articleName: 'test_article');

      expect(repo.memoryCachedArticles['test_article'] != null, true);
    },
  );
}
