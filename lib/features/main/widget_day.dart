// thanks to: https://github.com/FabioFiuza/scrollable_clean_calendar/blob/master/lib/widgets/days_widget.dart
import 'package:flutter/material.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';
import 'package:liceth_app/features/main/day_type.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

Widget getDayWidget(
    BuildContext context, DayValues values, List<PeriodWithId> periods) {
  BorderRadiusGeometry? borderRadius;
  Color bgColor = Colors.transparent;
  TextStyle txtStyle = (Theme.of(context).textTheme.bodyLarge)!.copyWith(
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: values.isFirstDayOfWeek || values.isLastDayOfWeek
        ? FontWeight.bold
        : null,
  );

  final radius = 6.0;

  final utcDate =
      DateTime.utc(values.day.year, values.day.month, values.day.day);
  final dayType = getDayType(utcDate, periods);

  if (dayType.dayType == DayType.PeriodStartOrEnd ||
      dayType.dayType == DayType.PeriodOther) {
    // if (values.isFirstDayOfWeek) {
    //   borderRadius = BorderRadius.only(
    //     topLeft: Radius.circular(radius),
    //     bottomLeft: Radius.circular(radius),
    //   );
    // } else if (values.isLastDayOfWeek) {
    //   borderRadius = BorderRadius.only(
    //     topRight: Radius.circular(radius),
    //     bottomRight: Radius.circular(radius),
    //   );
    // }

    final minRangeDate = parseYyyyMmDd(dayType.period!.start);
    final maxRangeDate = parseYyyyMmDd(dayType.period!.end);

    bgColor = Theme.of(context).colorScheme.primary.withOpacity(.3);
    txtStyle = (Theme.of(context).textTheme.bodyLarge)!.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: values.isFirstDayOfWeek || values.isLastDayOfWeek
          ? FontWeight.bold
          : null,
    );

    if ((minRangeDate != null && values.day.isSameDay(minRangeDate!)) ||
        (maxRangeDate != null && values.day.isSameDay(maxRangeDate!))) {
      // bgColor = Theme.of(context).colorScheme.primary;
      // txtStyle = (Theme.of(context).textTheme.bodyLarge)!.copyWith(
      //   color: Theme.of(context).colorScheme.onPrimary,
      //   fontWeight: FontWeight.bold,
      // );

      if (minRangeDate == maxRangeDate) {
        borderRadius = BorderRadius.circular(radius);
      } else if (minRangeDate != null && values.day.isSameDay(minRangeDate!)) {
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
        );
      } else if (maxRangeDate != null && values.day.isSameDay(maxRangeDate!)) {
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        );
      }
    }
  } else if (values.day.isSameDay(values.minDate)) {
  } else if (values.day.isBefore(values.minDate) ||
      values.day.isAfter(values.maxDate)) {
    txtStyle = (Theme.of(context).textTheme.bodyLarge)!.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
      decoration: TextDecoration.lineThrough,
      fontWeight: values.isFirstDayOfWeek || values.isLastDayOfWeek
          ? FontWeight.bold
          : null,
    );
  }

  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius,
    ),
    child: Text(
      values.text,
      textAlign: TextAlign.center,
      style: txtStyle,
    ),
  );
}
