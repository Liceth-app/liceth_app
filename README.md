# liceth_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Deploy Firestore Rules

```
firebase deploy --only firestore:rules
```

## About models/apis creation

Each time you modify/create/delete a `.model` file, you must run:
```
flutter pub run build_runner watch --delete-conflicting-outputs
```


## Acknowledgments

This repository includes code copied and/or modified from:
- https://github.com/jogboms/flutter_spinkit
- https://github.com/flutter/flutter

This repository uses libraries, see pubspec.yaml dependencies.