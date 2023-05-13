// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Period _$PeriodFromJson(Map<String, dynamic> json) => Period(
      uid: json['uid'] as String?,
      start: json['start'] as String? ?? minDate,
      end: json['end'] as String? ?? maxDate,
    );

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'uid': instance.uid,
      'start': instance.start,
      'end': instance.end,
    };

PeriodWithId _$PeriodWithIdFromJson(Map<String, dynamic> json) => PeriodWithId(
      id: json['id'] as String,
      uid: json['uid'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$PeriodWithIdToJson(PeriodWithId instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'start': instance.start,
      'end': instance.end,
      'id': instance.id,
    };
