<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This flutter package is helper for managing an article based website backed by
firebase.
It combines firebase firestore (managing methadata used to build Article model)
and and cloud storage ( hosting for example markdown files and images in the article).

The organisation of firestore should be as follow:
  - root/
      - articles/
                /some_article_title_as_firebase_doc_name/
                                                        /title
                                                        /id
                                                        /the_name_of_the_article_file_in_firebase_storage
                                                        /releaseDate
                                                        /relation_is_an_array_of_other_property_that_the_article_have
  

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
