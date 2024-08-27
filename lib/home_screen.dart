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
  final noteTextDialogController = TextEditingController();

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
                      '\na)	The coach sets the section length of the clean swim area that will be measured. If possible, we recommend using the standard clean swim area of 15-45 m (50m pool) or 10-20 m (25m pool). '
                          '\n\nb) The swimmer swim selected **section length**, while the coach measures the **time** and **SR**. '
                          '\n\nc) The coach inputs the **time** and **SR** in the app and press "calculate". The new swim time should  correspond the measured time (if not, please press the "calculate" button twice). '
                          '\n\nd) By adjsuting **SR/SL** you can observe potential changes in **new swim time**. '
                          '\n\n **SR**  ... stroke rate [cycles/min]'
                          '\n\n **SL** ... stroke length [m] '
                          '\n\n _Taping the "+" or "-" button will increase/decrease the value by 0.01 and while holding it will be changed by 0.1._');
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
                    'Version 1.1'
                        '\n\nOriginal idea: Raul Arellano '
                        '\n\nAuthor: umimplavat.cz '
                        '\n\nCreator: Vojtech Netrh '
                        '\n\nThis app calculates how potential changes in two key performance parameters - **stroke rate (_SR_)** and **stroke length (_SL_)** - affect the average clean swim time.'
                        ' **Swimming speed (_V_)** results from the optimal balance between **SR** and **SL** (_V = SR * SL_).'
                        ' Users can adjust **SR** and **SL** values to estimate potential average changes in clean swim time.'
                        ' The app calculates a new swim time by varying one parameter (e.g., increasing SR) while keeping the other constant, or by varying both parameters.'
                        ' This helps swimmers better understand how even small adjustments in **SR** or **SL** can significantly impact their swim times.',
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Image(
            image: AssetImage('assets/images/UMIM_logo_RGB-10.png'),
            height: 50,
          ),
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
                    const SizedBox(
                      height: 28,
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
                          width: 12,
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
                                Icon(
                                  Icons.delete_forever,
                                  size: 26,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
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
                      height: 28,
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
                                      final newSR = oldSR + 0.1;
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
                                        final newSR = oldSR + 0.01;
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
                                      final newSR = oldSR - 0.1;
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
                                        final newSR = oldSR - 0.01;
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
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Save data'),
              content: TextField(
                controller: noteTextDialogController,
                decoration: const InputDecoration(
                    labelText: 'Enter note for this record',
                    border: OutlineInputBorder()),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    noteTextDialogController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Discard',
                      style: TextStyle(color: Colors.red)),
                ),
                TextButton.icon(
                  onPressed: () {
                    doSaveValues(noteTextDialogController.text);
                    noteTextDialogController.clear();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ],
            ));
  }

  void doSaveValues(String noteText) async {
    var dateNow = DateTime.now();
    var formatedDate = DateFormat('HH:mm | dd. MM. yyyy').format(dateNow);
    var id = ShortUid.create();

    AllValues newRecord = AllValues(
        id: id,
        originalTime: double.parse(timeController.text),
        originalStrokeRate: double.parse(strokeRateController.text),
        sectionLength: double.parse(sectionLengthController.text),
        newTime: double.parse(resultTimeController.text),
        newStrokeRate: double.parse(strokeRateController2.text),
        newStrokeLength: double.parse(strokeLengthController.text),
        date: formatedDate,
        noteText: noteText);

    if (await DatabaseService.instance.addValue(newRecord)) {
      displaySnackBar(context, 'Data saved successfully!', color: Colors.green);
    } else {
      displaySnackBar(context, 'Data could not be saved!', color: Colors.red);
    }
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
