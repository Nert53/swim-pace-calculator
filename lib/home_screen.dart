import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hold_down_button/hold_down_button.dart';

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

  @override
  void initState() {
    strokeRateController2.addListener(() {
      updateResultTime();
    });
    strokeLengthController.addListener(() {
      updateResultTime();
    });
    super.initState();
  }

  void initialCalculation() {
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

    resultTimeController.text = time.toStringAsFixed(2);
    //resultTimeController.text =
    //   newSectionTime(length, strokeLength, strokeTime).toStringAsFixed(2);
    strokeRateController2.text = strokeRate.toStringAsFixed(2);
    strokeLengthController.text = strokeLength.toStringAsFixed(2);
  }

  double newSectionTime(double length, double strokeLength, double strokeTime) {
    return length / strokeLength * strokeTime;
  }

  void updateResultTime() {
    final sectionLength = double.parse(sectionLengthController.text);
    final strokeLength = double.parse(strokeLengthController.text);
    final strokeTime = 60 / double.parse(strokeRateController2.text);

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
            "AquaPace",
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
                child: const Text('umimplavat.cz'),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.noteSticky),
                title: const Text('How to use'),
                onTap: () {
                  _dialogInfo(
                      context,
                      'How to use',
                      'This app is used to calculate the time\n'
                          'of a section based on the stroke rate\n'
                          'and stroke length. The calculation is\n'
                          'based on the formulas:\n');
                },
              ),
              ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: const Text('Saved values'),
                onTap: () {
                  _dialogInfo(
                    context,
                    'Saved values',
                    'Will be added later',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About app'),
                onTap: () {
                  _dialogInfo(
                    context,
                    'About app',
                    'Version 0.9\n'
                        'Creator: Vojtech Netrh\n'
                        'Idea Maker: Marek Polach',
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
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.trending_up),
                      border: OutlineInputBorder(),
                      labelText: 'Stroke Rate [cylce/min]',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: sectionLengthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.straighten),
                      border: OutlineInputBorder(),
                      labelText: 'Section Length [m]',
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: initialCalculation,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.calculator),
                          SizedBox(width: 8),
                          Text(
                            "Calculate",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ]),
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
                      labelText: 'Result time [s]',
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
                          const Text('Stroke Rate [cycle/min]'),
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
                    onPressed: saveValues,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text(
                            "Save Values",
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
        ));
  }

  void saveValues() {}
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
            Text(content),
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
