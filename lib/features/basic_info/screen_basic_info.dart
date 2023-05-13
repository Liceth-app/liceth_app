import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liceth_app/features/basic_info/constants_basic_info.dart';
import 'package:liceth_app/features/basic_info/firestore_basic_info.dart';
import 'package:liceth_app/features/basic_info/period.model.dart';
import 'package:liceth_app/features/main/day_type.dart';
import 'package:liceth_app/features/main/screen_main.dart';
import 'package:liceth_app/util/toast.dart';
import 'package:liceth_app/util/widget/loader.dart';
import 'package:liceth_app/util/widget/vertical_space.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class BasicInfoScreen extends StatefulWidget {
  static const String routeName = '/BasicInfoScreen';
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _pickedDate;
  bool _isLoading = false;

  bool _saving = false;

  late Preference<bool> willLogPeriodsPref;

  @override
  void initState() {
    _dateController.text = ""; //set the initial value of text field
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return getFullScreenLoader();
    }

    // get safe area top padding
    final double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: <Widget>[
                    verticalSpace(topPadding),
                    verticalSpace(30),
                    DropShadow(
                      offset: const Offset(10, 10),
                      blurRadius: 20,
                      spread: 0.6,
                      child: Image.asset(
                        'assets/icons/droplet.png',
                        width: 70,
                      ),
                    ),
                    verticalSpace(30),
                    Text(
                      "¿Cuándo empezó tu último periodo?",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(120),
                    TextField(
                      controller:
                          _dateController, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Fecha" //label text of field
                          ),
                      readOnly: true, // when true user cannot edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          final appLocale =
                              Localizations.localeOf(context).toString();
                          // format the picked date in the locale format
                          String formattedDate =
                              DateFormat.yMMMEd(appLocale).format(pickedDate);

                          setState(() {
                            _dateController.text = formattedDate;
                            _pickedDate = pickedDate;
                          });
                        } else {
                          debugPrint("Date is not selected");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _saving
            ? const LinearProgressIndicator()
            : BottomAppBar(
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          // dialog to confirm if she/he has periods
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                bool? willLogPeriods;

                                return StatefulBuilder(
                                    builder: (context, mySetState) {
                                  return AlertDialog(
                                    title: const Text("¿Registrarás periodos?"),
                                    content:
                                        // radio buttons inside dialog body for willLogPeriods with RadioListTile
                                        Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RadioListTile(
                                          title: const Text(
                                              "Sí, registraré periodos luego"),
                                          value: true,
                                          groupValue: willLogPeriods,
                                          onChanged: (value) {
                                            mySetState(() {
                                              willLogPeriods = value;
                                            });
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text(
                                              "No, solo veré información compartida"),
                                          value: false,
                                          groupValue: willLogPeriods,
                                          onChanged: (value) {
                                            mySetState(() {
                                              willLogPeriods = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: willLogPeriods == null
                                              ? null
                                              : () =>
                                                  storeHasPeriodsAndContinue(
                                                      willLogPeriods!),
                                          child: const Text("Continuar")),
                                    ],
                                  );
                                });
                              });
                        },
                        child: const Text("Saltar")),
                    OutlinedButton(
                      onPressed: _pickedDate == null
                          ? null
                          : () {
                              saveAndContinue();
                            },
                      child: const Text('Continuar'),
                    ),
                  ],
                ),
              ));
  }

  void navigateNext() {
    Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final preferences = await StreamingSharedPreferences.instance;
      willLogPeriodsPref =
          preferences.getBool(prefKeyWillLogPeriods, defaultValue: true);

      final h = await hasLoggedPeriods();
      // is user said she/he won't log periods or has already logged periods
      if (!willLogPeriodsPref.getValue() || h) {
        navigateNext();
      }
    } catch (e) {
      toast("Error: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void saveAndContinue() async {
    setState(() {
      _saving = true;
    });
    try {
      // format the picked date in yyyy-MM-dd format
      final d = toYyyyMmDd(_pickedDate!);
      debugPrint(d);

      await storePeriod(Period(
        start: d,
        end: toYyyyMmDd(
            _pickedDate!.add(const Duration(days: defaultNewPeriodLength - 1))),
      ));

      navigateNext();
    } catch (e) {
      toast("Error: $e");
    }
    setState(() {
      _saving = false;
    });
  }

  void storeHasPeriodsAndContinue(bool willLogPeriods) async {
    setState(() {
      _saving = true;
    });
    try {
      // storing willLogPeriods
      await willLogPeriodsPref.setValue(willLogPeriods);

      navigateNext();
    } catch (e) {
      toast("Error: $e");
    }
    setState(() {
      _saving = false;
    });
  }
}
