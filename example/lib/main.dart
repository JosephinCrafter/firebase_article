import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseFirestore _firestore;
  late FirebaseStorage _firebaseStorage;

  @override
  void initState() {
    super.initState();

    _firestore = FirebaseFirestore.instance;
    _firestore.useFirestoreEmulator("localhost", 8081);

    _firebaseStorage = FirebaseStorage.instance;
    _firebaseStorage.useStorageEmulator("localhost", 9199);
  }

  @override
  Widget build(BuildContext context) {
    ArticlesRepository repo = ArticlesRepository<Article>(firestoreInstance: _firestore);
    return Scaffold(
      body: FutureBuilder(
        future: repo.getHighlighted(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
                future: _firebaseStorage
                    .ref()
                    .child("articles/light/light.md")
                    .getData(),
                builder: (context, snapshotStorage) {
                  if (snapshotStorage.hasData) {
                    return MarkdownWidget(
                        data: utf8.decode(snapshotStorage.data!.toList()));
                  } else if (snapshotStorage.hasError) {
                    return Center(
                      child: Text(
                          "Error Getting data from Storage:\n${snapshotStorage.error}"),
                    );
                  } else {
                    return const Center(
                      child: Text("Getting data from Storage"),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Error Occurred when fetching article:\n${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
