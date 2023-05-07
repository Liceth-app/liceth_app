import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreUserDocHandler<T> {
  final String collectionName;
  final Map<String, dynamic> Function(T) toJson;
  final T Function(Map) fromJson;

  FirestoreUserDocHandler(this.collectionName, this.toJson, this.fromJson);

  static Future<Wrapper<DocumentReference>> _getDocumentReferenceFromCollection(
      Future<CollectionReference> collectionFuture,
      {String? docId}) async {
    if (docId == null) {
      var user = _auth.currentUser;
      if (user == null) return Wrapper.notLoggedIn();
      docId = user.uid;
    }

    var c = await collectionFuture;
    var r = c.doc(docId);
    return Wrapper(r);
  }

  Future<CollectionReference> _getCollection() async {
    return FirebaseFirestore.instance.collection(collectionName);
  }

  Future<Wrapper<DocumentReference>> getDocumentReference(
      {String? docId}) async {
    return _getDocumentReferenceFromCollection(_getCollection(), docId: docId);
  }

  Future<void> storeDocument(T profile) async {
    var c = await getDocumentReference();
    final cvalue = c.value;
    if (cvalue == null) return;

    try {
      await cvalue.set(toJson(profile));
    } catch (e, s) {
      debugPrint(s.toString());
    }
  }

  Future<Wrapper<T>> getDocument(
      {bool localThenServer = false, String? docId}) async {
    var r = await getDocumentReference(docId: docId);
    if (r.status == LoginStatus.NOT_LOGGED_IN) return Wrapper.notLoggedIn();
    final rvalue = r.value;
    if (rvalue == null) {
      // should never happen?
      throw Exception("Not valueNotNull");
    }
    try {
      DocumentSnapshot sn;
      if (localThenServer) {
        try {
          sn = await rvalue.get(const GetOptions(source: Source.cache));
        } catch (e) {
          // local value not found
          sn = await rvalue.get();
        }
      } else {
        // regular: server first and if it fails then local cache
        sn = await rvalue.get();
      }
      final data = sn.data();
      if (data == null) {
        // this happens when the document doesnt exist
        return Wrapper(null);
      }
      return Wrapper(fromJson(data as Map<String, dynamic>));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      FirebaseCrashlytics.instance.recordError(e, s);
    }
    return Wrapper(null);
  }
}

class Wrapper<T> {
  /**
   * Null if the document doesnt exist
   */
  T? value;
  LoginStatus status;

  bool get valueNotNull => value != null;

  Wrapper(this.value, {this.status = LoginStatus.LOGGED_IN});

  factory Wrapper.notLoggedIn() {
    return Wrapper(null, status: LoginStatus.NOT_LOGGED_IN);
  }
}

enum LoginStatus { NOT_LOGGED_IN, LOGGED_IN }
