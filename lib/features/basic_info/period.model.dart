import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'period.model.g.dart';

const maxDate = "3000-01-01";
const minDate = "1900-01-01";

@JsonSerializable(explicitToJson: true)
class Period {
  String uid; // user id
  String start; // yyyy-MM-dd, defaults to minDate
  String end; // yyyy-MM-dd, defaults to maxDate

  Period({
    String? uid,
    this.start = minDate,
    this.end = maxDate,
  }) : uid = uid ?? FirebaseAuth.instance.currentUser!.uid;

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PeriodWithId extends Period {
  String id;

  PeriodWithId({
    required this.id,
    required String uid,
    required String start,
    required String end,
  }) : super(uid: uid, start: start, end: end);

  PeriodWithId.fromPeriod(this.id, Period period) {
    uid = period.uid;
    start = period.start;
    end = period.end;
  }

  factory PeriodWithId.fromJson(Map<String, dynamic> json) =>
      _$PeriodWithIdFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodWithIdToJson(this);
}
