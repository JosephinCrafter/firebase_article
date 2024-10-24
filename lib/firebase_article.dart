library firebase_article;

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import 'src/firebase_constants.dart';


export 'src/view/article_view.dart';

part 'src/model/article.dart';
part 'src/repo/articles_repository.dart';
