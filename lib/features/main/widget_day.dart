// thanks to: https://github.com/FabioFiuza/scrollable_clean_calendar/blob/master/lib/widgets/days_widget.dart
import 'package:flutter/material.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';
import 'package:liceth_app/features/main/day_type.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

bool isPeriodDay(List<PeriodWithId> periods, DateTime day) {
  return periods.any((p) {
    return p.start.compareTo(toYyyyMmDd(day)) <= 0 &&
        p.end.compareTo(toYyyyMmDd(day)) >= 0;
  });
}

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

  final isPeriod = isPeriodDay(periods, values.day);

  if (isPeriod) {
    if (values.isFirstDayOfWeek) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );
    } else if (values.isLastDayOfWeek) {
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    }

    if ((values.selectedMinDate != null &&
            values.day.isSameDay(values.selectedMinDate!)) ||
        (values.selectedMaxDate != null &&
            values.day.isSameDay(values.selectedMaxDate!))) {
      bgColor = Theme.of(context).colorScheme.primary;
      txtStyle = (Theme.of(context).textTheme.bodyLarge)!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      );

      if (values.selectedMinDate == values.selectedMaxDate) {
        borderRadius = BorderRadius.circular(radius);
      } else if (values.selectedMinDate != null &&
          values.day.isSameDay(values.selectedMinDate!)) {
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
        );
      } else if (values.selectedMaxDate != null &&
          values.day.isSameDay(values.selectedMaxDate!)) {
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        );
      }
    } else {
      bgColor = Theme.of(context).colorScheme.primary.withOpacity(.3);
      txtStyle = (Theme.of(context).textTheme.bodyLarge)!.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: values.isFirstDayOfWeek || values.isLastDayOfWeek
            ? FontWeight.bold
            : null,
      );
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
