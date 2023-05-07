import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'period.model.g.dart';

const maxDate = "3000-01-01";
const minDate = "1900-01-01";

@JsonSerializable(explicitToJson: true)
class Period {
  String uid; // user id
  String start; // yyyy-MM-dd, defaults to 1900-01-01
  String end; // yyyy-MM-dd, defaults to 3000-01-01

  String get docId => "${uid}_$start";

  Period({
    String? uid,
    this.start = minDate,
    this.end = maxDate,
  }) : uid = uid ?? FirebaseAuth.instance.currentUser!.uid;

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}
