import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    super.initState();
    strokeRateController2.addListener(() {
      updateResultTime();
    });
    strokeLengthController.addListener(() {
      updateResultTime();
    });
  }

  void initialCalculation() {
    final time = double.parse(timeController.text);
    final strokeRate = double.parse(strokeRateController.text);
    final length = double.parse(sectionLengthController.text);

    double strokeTime = 60 / strokeRate;
    double avgSpeed = length / time;
    double strokeLength = avgSpeed * strokeTime;

    resultTimeController.text =
        newSectionTime(length, strokeLength, strokeTime).toStringAsFixed(2);
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
            "umimplavat.cz",
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
                  _dialogInfo(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About app'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.timer),
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
                        Icon(Icons.add_circle_outlined),
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
                    prefixIcon: const Icon(Icons.label),
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
                              FloatingActionButton(
                                onPressed: () {
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
                                child: const Icon(Icons.add_outlined),
                              ),
                              FloatingActionButton(
                                onPressed: () {
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
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: const Icon(Icons.remove),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
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
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    final oldSL = double.parse(
                                        strokeLengthController.text);
                                    final newSL = oldSL + 0.05;

                                    if (newSL > 0) {
                                      strokeLengthController.text =
                                          (newSL).toStringAsFixed(2);
                                    }
                                  });
                                },
                                child: const Icon(Icons.add_outlined),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    final oldSL = double.parse(
                                        strokeLengthController.text);
                                    final newSL = oldSL - 0.05;
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
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

Future<void> _dialogInfo(BuildContext context) {
  Navigator.pop(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('How to use this app'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This app is used to calculate the time\n'
                'of a section based on the stroke rate\n'
                'and stroke length. The calculation is\n'
                'based on the formulas:\n'),
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
