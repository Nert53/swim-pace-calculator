import 'package:code/data/database_service.dart';
import 'package:code/model/all_values.dart';
import 'package:flutter/material.dart';

class SavedValuesScreen extends StatefulWidget {
  const SavedValuesScreen({super.key});

  @override
  State<SavedValuesScreen> createState() => _SavedValuesScreenState();
}

class _SavedValuesScreenState extends State<SavedValuesScreen> {
  late List<AllValues> _records = [];
  bool isLoading = false;

  Future<void> _getAllRecords() async {
    setState(() {
      isLoading = true;
    });

    _records = await DatabaseService.instance.getValues();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getAllRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Values'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: Colors.black,
            tooltip: 'View help.',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Explenations'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.timer_outlined),
                            SizedBox(width: 8),
                            Text('... original measured time'),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.trending_up_outlined),
                            SizedBox(width: 8),
                            Text('... original measured SR'),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.straighten_outlined),
                            SizedBox(width: 8),
                            Text('... original measured section length'),
                          ],
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.timer,
                                color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 8),
                            Text('... calculated time'),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.trending_up,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 8),
                            Text('... calculated SR'),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            ImageIcon(
                              AssetImage('assets/icons/arrow_range.png'),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 8),
                            Text('... calculated SL'),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : _records.isEmpty
                  ? const Text('No values added yet.',
                      style: TextStyle(fontSize: 20))
                  : buildValueList()),
    );
  }

  Widget buildValueList() {
    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: ListTile(
            key: Key(record.id),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.timer_outlined),
                    const SizedBox(width: 8),
                    Text('${record.originalTime} s'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.trending_up_outlined),
                    const SizedBox(width: 8),
                    Text('${record.originalStrokeRate} cycles/min'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.straighten_outlined),
                    const SizedBox(width: 8),
                    Text('${record.sectionLength} m'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text('${record.newTime} s'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.trending_up,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8),
                    Text('${record.newStrokeRate} cycles/min'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/icons/arrow_range.png'),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8),
                    Text('${record.newStrokeLength} m'),
                  ],
                )
              ],
            ),
            subtitle: Text('Saved on: ${record.date}',
                style: const TextStyle(color: Colors.blueGrey)),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_outlined,
                color: Colors.red,
                size: 30,
              ),
              tooltip: 'Permanently delete this values.',
              onPressed: () async {
                await DatabaseService.instance.deleteValue(record.id);
                _getAllRecords();
              },
            ),
          ),
        );
      },
    );
  }
}
