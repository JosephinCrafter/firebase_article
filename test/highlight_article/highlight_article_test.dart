import 'package:firebase_article/firebase_article.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  final FirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
  late ArticlesRepository repo;
  setUp(
    () {
      repo = ArticlesRepository(
        firestoreInstance: fakeFirestore,
      );
      Map<String, dynamic> data = {
        'id': 'saint_dominique',
        'title': 'Neuvaine avec Saint Dominique - Jour 1',
      };
      fakeFirestore.doc('/neuvaines/saint_dominique_jours1').set(data);
      fakeFirestore.doc('/articles/setup').set(
        {'highLight': '/neuvaines/saint_dominique_jours1'},
      );
    },
  );
  group(
    'test on path highlight article',
    () {
      test(
        'Get article from backends with a path',
        () async {
          String neuvainePath = '/neuvaines/saint_dominique_jours1';

          Article? neuvaine = await repo.getArticleByPath(path: neuvainePath);

          expect(neuvaine!.id, 'saint_dominique');
        },
      );
      test(
        'Get highlighted article from path setup in setup',
        () async {
          Article? highLightArticle = await repo.getHighlighted();

          expect(highLightArticle!.id, 'saint_dominique');
        },
      );
    },
  );

  test(
    'ArticleId based highlight articles is working',
    () async {
      fakeFirestore
          .doc('/articles/setup')
          .set({"highLight": 'high_light_article'});

      fakeFirestore.doc('/articles/high_light_article').set({
        'id': 'high_light_article',
      });

      Article? idHighLightArticle = await repo.getHighlighted();

      expect(idHighLightArticle!.id, 'high_light_article');
    },
  );

  group(
    'Highlight Collection',
    () {
      test(
        'Getting Highlight collection with path',
        () async {
          fakeFirestore
              .doc('/articles/setup')
              .update({'highLight': '/novena/saint_dominic_jour_1'});

          String? highlightCollection = await repo.getHighlightedCollection();

          expect(highlightCollection, '/novena');
        },
      );

      test(
        'Getting Highlight collection with id',
        () async {
          fakeFirestore
              .doc('/articles/setup')
              .update({'highLight': 'saint_dominic_jour_1'});

          String? highlightCollection = await repo.getHighlightedCollection();

          expect(highlightCollection, '/articles');
        },
      );
    },
  );
}
