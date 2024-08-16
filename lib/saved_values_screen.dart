import 'package:flutter/material.dart';

class SavedValuesScreen extends StatelessWidget {
  const SavedValuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Values'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Center(
            child: ListView(
          children: <Widget>[
            const Divider(),
            ListTile(
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.timer_outlined),
                      SizedBox(width: 8),
                      Text('Value'),
                      Text(' [s]')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.trending_up_outlined),
                      SizedBox(width: 8),
                      Text('Value 1 cycle/min'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.straighten_outlined),
                      SizedBox(width: 8),
                      Text('Value 1 m'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      ImageIcon(AssetImage("assets/icons/arrow_range.png")),
                      SizedBox(width: 8),
                      Text('Value 1 m'),
                    ],
                  )
                ],
              ),
              subtitle: const Text('11. 07. 2021 12:34:56',
                  style: TextStyle(color: Colors.blueGrey)),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Colors.red,
                  size: 28,
                ),
                tooltip: 'Permanently delete this values.',
                onPressed: () {},
              ),
            ),
            const Divider(),
          ],
        )));
  }
}
