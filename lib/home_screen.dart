import 'package:code/data/database_service.dart';
import 'package:code/model/all_values.dart';
import 'package:code/saved_values_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hold_down_button/hold_down_button.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shortuid/shortuid.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final timeController = TextEditingController();
  final strokeRateController = TextEditingController();
  final sectionLengthController = TextEditingController();
  final resultTimeController = TextEditingController();
  final strokeRateController2 = TextEditingController();
  final strokeLengthController = TextEditingController();

  var resulTimeColor = Colors.black;
  bool calculateButtonClick = false;

  @override
  void initState() {
    strokeRateController2.addListener(() {
      updateResultTime();
    });
    strokeLengthController.addListener(() {
      updateResultTime();
      super.initState();
    });
  }

  void initialCalculation() {
    calculateButtonClick = true;
    if (timeController.text.isEmpty ||
        strokeRateController.text.isEmpty ||
        sectionLengthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields!'),
          duration: const Duration(milliseconds: 2500),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return;
    }

    final time = double.parse(timeController.text);
    final strokeRate = double.parse(strokeRateController.text);
    final length = double.parse(sectionLengthController.text);

    double strokeTime = 60 / strokeRate;
    double avgSpeed = length / time;
    double strokeLength = avgSpeed * strokeTime;

    setState(() {
      resultTimeController.text = time.toStringAsFixed(2);
      strokeRateController2.text = strokeRate.toStringAsFixed(2);
      strokeLengthController.text = strokeLength.toStringAsFixed(2);
    });
  }

  double newSectionTime(double length, double strokeLength, double strokeTime) {
    return length / strokeLength * strokeTime;
  }

  void updateResultTime() {
    final sectionLength = double.parse(sectionLengthController.text);
    final strokeLength = double.parse(strokeLengthController.text);
    final strokeTime = 60 / double.parse(strokeRateController2.text);

    if (calculateButtonClick) {
      resultTimeController.text = double.parse(timeController.text)
          .toStringAsFixed(
              2); // value will always be displayed wit 2 decimal places
      updateResultTimeColor();
      calculateButtonClick = false;
      return;
    }

    final DatabaseService _databaseService = DatabaseService.instance;

    setState(() {
      resultTimeController.text =
          newSectionTime(sectionLength, strokeLength, strokeTime)
              .toStringAsFixed(2);
      updateResultTimeColor();
    });
  }

  void updateResultTimeColor() {
    final originalTime = double.parse(timeController.text);
    final resultTime = double.parse(resultTimeController.text);

    if (resultTime > originalTime) {
      resulTimeColor = Colors.red;
    }
    if (resultTime < originalTime) {
      resulTimeColor = Colors.green;
    }
    if (resultTime == originalTime) {
      resulTimeColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text(
            "Swim Pace Calculator",
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets
                .zero, // zpusobi ze se menu zobrazi barevne od horniho okraje
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: const Text(
                  'Swim Pace Calculator',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.noteSticky),
                title: const Text('How to use'),
                onTap: () {
                  _dialogInfo(
                      context,
                      'How to use',
                      '\na) The coach set the **section length** of the clean swim area that is gonna be measured. '
                          '\n\nb) The swimmer swim selected **section length**, while the coach measures the **time** and **SR**. '
                          '\n\nc) Coach adds the **time** and **SR** in the app and press calculate (result time should be equal to the time, that the coach measured). '
                          '\n\nd) By increasing or decreasing **SR/SL** you can observe potential changes in **result time**. '
                          '\n\n **SR**  ... stroke rate [cycles/min]'
                          '\n\n **SL** ... stroke length [m] '
                          '\n\n _Taping the "+" or "-" button will increase/decrease the value by 0.01 and if hold it it will be changed by 0.1._');
                },
              ),
              ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: const Text('Saved data'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SavedValuesScreen();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About app'),
                onTap: () {
                  _dialogInfo(
                    context,
                    'About app',
                    'Version 0.9'
                        '\n\nCreator: Vojtech Netrh'
                        '\n\nIdea Maker: Marek Polach (umimplavat.cz)'
                        '\n\nThis app serves to calculate potential average changes in clean swim time based on the change of two main parameters responsible for swimming speed: **stroke rate (_SR_)** and **stroke length (_SL_)**.'
                        ' **Swimming speed (_V_)** is calculated as _V = SR * SL_. The hypothetical **new swim time** is calculated by adjusting one parameter while maintaining the second parameter constant (unchanged). By inputting different values for _SR_ and _SL_, users can see how potential changes in _SR_ or _SL_ (or both) could theoretically affect their **clean swim time**.'
                        ' The average recalculation of the **new swim time** works under the assumption of changing one parameter (e.g., increasing _SR_) while keeping the second parameter constant (e.g., increased _SR_ with the same _SL_ as before). The **new swim time** is a potential prediction of how the swimmer would reduce his/her **clean swim time** based on the corresponding aforementioned _SR/SL_ change.',
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('© umimplavat.cz 2024',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380, minWidth: 340),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'(^-?\d*\.?\d*)')) // allows only decimal numbers to enter (with dot)
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.timer_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Time [s]',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: strokeRateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'(^-?\d*\.?\d*)')) // allows only decimal numbers to enter (with dot)
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.trending_up),
                        border: OutlineInputBorder(),
                        labelText: 'Stroke Rate [cyclces/min]',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: sectionLengthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'(^-?\d*\.?\d*)')) // allows only decimal numbers to enter (with dot)
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.straighten),
                        border: OutlineInputBorder(),
                        labelText: 'Section Length [m]',
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: initialCalculation,
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.calculator),
                                  SizedBox(width: 8),
                                  Text(
                                    'Calculate',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              timeController.clear();
                              strokeRateController.clear();
                              sectionLengthController.clear();
                              resultTimeController.clear();
                              strokeRateController2.clear();
                              strokeLengthController.clear();
                            });
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.clear),
                                SizedBox(width: 8),
                                Text(
                                  'Clear',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextField(
                      controller: resultTimeController,
                      readOnly: true,
                      style: TextStyle(
                          color: resulTimeColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.label_important_outline),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                        ),
                        labelText: 'New swim time [s]',
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            TextField(
                              controller: strokeRateController2,
                              readOnly: true,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('Stroke Rate [cycles/min]'),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSR = double.parse(
                                          strokeRateController2.text);
                                      final newSR = oldSR + 1;
                                      if (newSR > 0) {
                                        strokeRateController2.text =
                                            (newSR).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        final oldSR = double.parse(
                                            strokeRateController2.text);
                                        final newSR = oldSR + 0.1;
                                        if (newSR > 0) {
                                          strokeRateController2.text =
                                              (newSR).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add_outlined),
                                  ),
                                ),
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSR = double.parse(
                                          strokeRateController2.text);
                                      final newSR = oldSR - 1;
                                      if (newSR > 0) {
                                        strokeRateController2.text =
                                            (newSR).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        final oldSR = double.parse(
                                            strokeRateController2.text);
                                        final newSR = oldSR - 0.1;
                                        if (newSR > 0) {
                                          strokeRateController2.text =
                                              (newSR).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: const Icon(Icons.remove_outlined),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            TextField(
                              controller: strokeLengthController,
                              readOnly: true,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('Stroke Length [m]'),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSL = double.parse(
                                          strokeLengthController.text);
                                      final newSL = oldSL + 0.1;
                                      if (newSL > 0) {
                                        strokeLengthController.text =
                                            (newSL).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        final oldSL = double.parse(
                                            strokeLengthController.text);
                                        final newSL = oldSL + 0.01;

                                        if (newSL > 0) {
                                          strokeLengthController.text =
                                              (newSL).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add_outlined),
                                  ),
                                ),
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSL = double.parse(
                                          strokeLengthController.text);
                                      final newSL = oldSL - 0.1;
                                      if (newSL > 0) {
                                        strokeLengthController.text =
                                            (newSL).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        final oldSL = double.parse(
                                            strokeLengthController.text);
                                        final newSL = oldSL - 0.01;
                                        if (newSL > 0) {
                                          strokeLengthController.text =
                                              (newSL).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: const Icon(Icons.remove),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (resultTimeController.text.isNotEmpty) {
                          saveValues();
                          displaySnackBar(context, 'Data saved successfully!',
                              color: Colors.green);
                        } else {
                          displaySnackBar(context,
                              'Please calculate the result time first!');
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text(
                              "Save Data",
                              style: TextStyle(fontSize: 18),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void saveValues() async {
    var dateNow = DateTime.now();
    var formatedDate = DateFormat('HH:mm | yyyy-MM-dd').format(dateNow);
    var id = ShortUid.create();

    AllValues newRecord = AllValues(
        id: id,
        originalTime: timeController.text,
        originalStrokeRate: strokeRateController.text,
        sectionLength: sectionLengthController.text,
        newTime: resultTimeController.text,
        newStrokeRate: strokeRateController2.text,
        newStrokeLength: strokeLengthController.text,
        date: formatedDate);

    await DatabaseService.instance.addValue(newRecord);
  }
}

void displaySnackBar(BuildContext context, String message,
    {Color color = Colors.grey}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 2500),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

Future<void> _dialogInfo(BuildContext context, String title, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: content,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
