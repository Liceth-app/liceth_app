import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liceth_app/features/basic_info/firestore_basic_info.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';
import 'package:liceth_app/features/main/day_type.dart';
import 'package:liceth_app/features/main/firestore_periods.dart';
import 'package:liceth_app/features/main/widget_day.dart';
import 'package:liceth_app/util/toast.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class CalendarPage extends StatefulWidget {
  final List<PeriodWithId> periods;

  const CalendarPage({super.key, required this.periods});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CleanCalendarController calendarController;

  @override
  void initState() {
    calendarController = CleanCalendarController(
      minDate: DateTime.now().subtract(const Duration(days: 365)),
      maxDate: DateTime.now(),
      onRangeSelected: (startDate, endDate) {
        calendarController.clearSelectedDates();
        // toast('Range selected: $startDate - $endDate');
      },
      onDayTapped: onDayClicked,
      // readOnly: true, // default is false, so we can capture onDayTapped events
      weekdayStart: DateTime.monday,
      initialFocusDate: DateTime.now(),
      // initialDateSelected: DateTime(2022, 3, 15),
      // endDateSelected: DateTime(2022, 3, 20),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context).toString();
    return ScrollableCleanCalendar(
      calendarController: calendarController,
      layout: Layout.BEAUTY,
      calendarCrossAxisSpacing: 0,
      locale: appLocale,
      dayBuilder: (ctx, values) => getDayWidget(ctx, values, widget.periods),
    );
  }

  void onDayClicked(DateTime date) async {
    // create UTC date from year, month, day
    final utcDate = DateTime.utc(date.year, date.month, date.day);

    // get the day type for the date
    final dayType = getDayType(utcDate, widget.periods);

    // format the picked date in the locale format
    final appLocale = Localizations.localeOf(context).toString();
    String formattedDate = DateFormat.yMMMEd(appLocale).format(date);

    // get the current date in UTC
    final now = DateTime.now();
    final nowUtc = DateTime.utc(now.year, now.month, now.day);

    String question = dayType.dayType == DayType.PeriodOther
        ? "¿Eliminar periodo del\n${DateFormat.yMMMEd(appLocale).format(parseYyyyMmDd(dayType.period!.start))} \nal\n${DateFormat.yMMMEd(appLocale).format(parseYyyyMmDd(dayType.period!.end))}?"
        : nowUtc.isAtSameMomentAs(utcDate)
            ? "¿Estás con tu periodo hoy?"
            : dayType.dayType == DayType.NonPeriodOther
                ? "¿Tu periodo inició el $formattedDate?"
                : "¿Estuviste con tu periodo el $formattedDate?";

    // show dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              if (dayType.dayType == DayType.PeriodStartOrEnd) {
                final period = dayType.period!;

                // delete border day of period
                final start = parseYyyyMmDd(period.start);
                final end = parseYyyyMmDd(period.end);

                if (utcDate.isAtSameMomentAs(start)) {
                  period.start = toYyyyMmDd(start.add(const Duration(days: 1)));
                } else {
                  period.end =
                      toYyyyMmDd(end.subtract(const Duration(days: 1)));
                }

                if (parseYyyyMmDd(period.end)
                    .isBefore(parseYyyyMmDd(period.start))) {
                  // delete if end is before start
                  await deletePeriod(period.id);
                } else {
                  await updatePeriod(period);
                }
              }
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              if (dayType.dayType == DayType.PeriodOther) {
                final period = dayType.period!;
                await deletePeriod(period.id);
              } else if (dayType.dayType == DayType.NonPeriodNextToPeriod) {
                final period = dayType.period!;
                final period2 = dayType.period2;

                if (period2 == null) {
                  // expand period
                  final start = parseYyyyMmDd(period.start);

                  if (utcDate
                      .add(const Duration(days: 1))
                      .isAtSameMomentAs(start)) {
                    period.start = toYyyyMmDd(utcDate);
                  } else {
                    period.end = toYyyyMmDd(utcDate);
                  }

                  await updatePeriod(period);
                } else {
                  // sandwich, so we delete period2 and expand period up to period2 end
                  await deletePeriod(period2.id);
                  period.end = period2.end;
                  await updatePeriod(period);
                }
              } else if (dayType.dayType == DayType.NonPeriodOther) {
                // create new period
                final closestNextPeriod = dayType.period;
                var newPeriodEndUtc = utcDate
                    .add(const Duration(days: defaultNewPeriodLength - 1));
                if (closestNextPeriod != null) {
                  final closestNextPeriodStart =
                      parseYyyyMmDd(closestNextPeriod.start);
                  final closestNextPeriodEndMinus2 =
                      closestNextPeriodStart.subtract(const Duration(days: 2));

                  if (closestNextPeriodEndMinus2.isBefore(newPeriodEndUtc)) {
                    newPeriodEndUtc = closestNextPeriodEndMinus2;
                  }
                }

                await storePeriod(Period(
                  start: toYyyyMmDd(utcDate),
                  end: toYyyyMmDd(newPeriodEndUtc),
                ));
              }
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
  }
}
