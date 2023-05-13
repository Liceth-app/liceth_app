import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liceth_app/features/basic_info/firestore_basic_info.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';

Stream<List<PeriodWithId>> periodsStream() {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final q = FirebaseFirestore.instance
      .collection(periodsCollectionName)
      .where("uid", isEqualTo: uid)
      .orderBy("start", descending: false);
      
  return q.snapshots().map((event) =>
      event.docs.map((e) => PeriodWithId.fromJson(e.data())).toList());
}

Future<void> updatePeriod(PeriodWithId period) async {
  return await FirebaseFirestore.instance
      .collection(periodsCollectionName)
      .doc(period.id)
      .update(period.toJson());
}

Future<void> deletePeriod(String id) async {
  return await FirebaseFirestore.instance
      .collection(periodsCollectionName)
      .doc(id)
      .delete();
}
