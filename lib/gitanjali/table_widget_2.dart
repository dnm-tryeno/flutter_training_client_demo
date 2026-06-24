// import 'package:flutter/material.dart';

// class Tablewidgets2 extends StatelessWidget {
//   const Tablewidgets2({Key? key}) : super(key: key);

//   static const String _title = 'My Table Example';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: MySimpleTabl(),
//       ),
//     );
//   }
// }

// class MySimpleTable {}

// class MySimpleTabl extends StatelessWidget {
//   const MySimpleTabl({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       columns: <DataColumn>[
//         DataColumn(
//           label: Text(
//             'Student Name',
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Text(
//             'Roll no.',
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Text(
//             'Marks',
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Text(
//             'Positon',
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//       rows: const <DataRow>[
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Shanvi')),
//             DataCell(Text('1')),
//             DataCell(Text('455/500')),
//             DataCell(Text('1st')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Rihana')),
//             DataCell(Text('2')),
//             DataCell(Text('395/500')),
//             DataCell(Text('2nd')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Unnati')),
//             DataCell(Text('3')),
//             DataCell(Text('499/500')),
//             DataCell(Text('1st')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Utkarsh')),
//             DataCell(Text('4')),
//             DataCell(Text('350/500')),
//             DataCell(Text('3rd')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Alix')),
//             DataCell(Text('5')),
//             DataCell(Text('345/500')),
//             DataCell(Text('4th')),
//           ],
//         ),
//       ],
//     );
//   }
// }

// Adjustable Table Widget

import 'package:flutter/material.dart';

void main() {
  runApp(Table2());
}

class Table2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Adjustable Table Rows'),
        ),
        body: Center(
          child: Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'Name'),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Details '),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text('John Doe'),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          '123 Main St, City, Country\nAdditional details...'),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Jane jshbjhbdhjbdchjbsdjhnzbncxb nzbnmbzxmnbmnxzbmnzxbnmxbnbxzmnbxznbnxzbmnzxbnxzbnmxzbnmxnxcbnmzbmnxcmnxzbnmxbznbxznmbzxnmbxznmbzxnbjdshbdnbcnxz Smith'),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          '456 Elm St, Another City, Another Country\nMore details...'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
