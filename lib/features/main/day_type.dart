import 'package:liceth_app/features/basic_info/period.model.dart';

const defaultNewPeriodLength =
    4; // TODO: in the future maybe get this from the average of past periods

DateTime parseYyyyMmDd(String date) {
  final parts = date.split("-");
  return DateTime.utc(
      int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

String toYyyyMmDd(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

DayTypeWithPeriod getDayType(
    DateTime utcDate, List<PeriodWithId> orderedPeriods) {
  int i = 0;
  PeriodWithId? closestNextPeriod;

  for (final period in orderedPeriods) {
    final start = parseYyyyMmDd(period.start);
    final end = parseYyyyMmDd(period.end);

    final nextPeriod =
        i + 1 < orderedPeriods.length ? orderedPeriods[i + 1] : null;

    if (utcDate.isAtSameMomentAs(start) || utcDate.isAtSameMomentAs(end)) {
      return DayTypeWithPeriod(DayType.PeriodStartOrEnd, period);
    } else if (utcDate.isAfter(start) && utcDate.isBefore(end)) {
      return DayTypeWithPeriod(DayType.PeriodOther, period);
    } else if (utcDate
            .isAtSameMomentAs(start.subtract(const Duration(days: 1))) ||
        utcDate.isAtSameMomentAs(end.add(const Duration(days: 1)))) {
      // If one day before the next period, then we are in a sandwich case,
      // I mean, in between two period days: period, non-period, period
      if (nextPeriod != null) {
        final nextPeriodStart = parseYyyyMmDd(nextPeriod.start);
        if (utcDate.isAtSameMomentAs(
            nextPeriodStart.subtract(const Duration(days: 1)))) {
          return DayTypeWithPeriod(DayType.NonPeriodNextToPeriod, period,
              period2: nextPeriod);
        }
      }

      return DayTypeWithPeriod(DayType.NonPeriodNextToPeriod, period);
    }

    if (utcDate.isBefore(start)) {
      closestNextPeriod ??= period;
    }

    i++;
  }

  return DayTypeWithPeriod(DayType.NonPeriodOther, closestNextPeriod);
}

class DayTypeWithPeriod {
  final DayType dayType;
  final PeriodWithId?
      period; // only for DayType.PeriodStartOrEnd, DayType.PeriodOther and DayType.NonPeriodNextToPeriod
  final PeriodWithId?
      period2; // only in case of sandwich in DayType.NonPeriodNextToPeriod

  DayTypeWithPeriod(this.dayType, this.period, {this.period2});
}

enum DayType {
  PeriodStartOrEnd,
  PeriodOther,
  NonPeriodNextToPeriod,
  NonPeriodOther,
}
