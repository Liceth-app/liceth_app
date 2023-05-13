import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';

const periodsCollectionName = "periods";

Future<bool> hasLoggedPeriods() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final q = FirebaseFirestore.instance
      .collection(periodsCollectionName)
      .where("uid", isEqualTo: uid)
      .limit(1);
  var r = await q.get();
  return r.docs.isNotEmpty;
}

Future<void> storePeriod(Period period) async {
  final ref =
      FirebaseFirestore.instance.collection(periodsCollectionName).doc();
  return await ref.set(PeriodWithId.fromPeriod(ref.id, period).toJson());
}
