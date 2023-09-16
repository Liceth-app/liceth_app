import 'package:flutter/material.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';
import 'package:liceth_app/features/calendar/calendar_page.dart';
import 'package:liceth_app/features/main/firestore_periods.dart';
import 'package:liceth_app/features/main/page_wrapper.dart';
import 'package:liceth_app/features/share/share_page.dart';
import 'package:liceth_app/util/widget/loader.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            // icon: Icon(Icons.perm_contact_cal),
            // icon: Icon(Icons.person_add),
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'Compartir',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_rounded),
            selectedIcon: Icon(Icons.menu),
            label: 'Otros',
          ),
        ],
      ),
      body: PageWrapper(
          child: <Widget>[
        StreamBuilder<List<PeriodWithId>>(
            stream: periodsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SelectableText('Error: ${snapshot.error!}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader(
                  applyBackground: false,
                );
              }
              return CalendarPage(periods: snapshot.data ?? []);
            }),
        SharePage(),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
      ][currentPageIndex]),
    );
  }
}
