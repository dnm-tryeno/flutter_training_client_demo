import 'package:flutter/material.dart';

class Tablewidgets1 extends StatelessWidget {
  const Tablewidgets1({Key? key}) : super(key: key);

  static const String _title = 'My Table Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MySimpleTabl(),
      ),
    );
  }
}

class MySimpleTable {}

class MySimpleTabl extends StatelessWidget {
  const MySimpleTabl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Product',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Qty',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Rate',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Total',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Mango')),
            DataCell(Text('27')),
            DataCell(Text('10')),
            DataCell(Text('270')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Banana')),
            DataCell(Text('25')),
            DataCell(Text('10')),
            DataCell(Text('250')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Cake')),
            DataCell(Text('50')),
            DataCell(Text('10')),
            DataCell(Text('500')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Horlicks')),
            DataCell(Text('10')),
            DataCell(Text('10')),
            DataCell(Text('100')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Orange')),
            DataCell(Text('80')),
            DataCell(Text('10')),
            DataCell(Text('800')),
          ],
        ),
      ],
    );
  }
}
