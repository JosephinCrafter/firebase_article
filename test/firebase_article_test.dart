import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:firebase_article/src/firebase_constants.dart';
import 'package:firebase_article/firebase_article.dart';

void main() {
  test('getContent', () {
    FirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
    ArticlesRepository(firestoreInstance: fakeFirestore);
  });
}
