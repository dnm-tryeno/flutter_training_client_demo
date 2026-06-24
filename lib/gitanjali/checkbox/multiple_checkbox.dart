/*import 'package:flutter/material.dart';

class MultipleCheckBox extends StatelessWidget {
  const MultipleCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Multiple Checkbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyMultipleCheckBox(),
    );
  }
}

class MyMultipleCheckBox extends StatefulWidget {
  const MyMultipleCheckBox({Key? key}) : super(key: key);
  //final String title;

  @override
  _MyMultipleCheckBoxState createState() => _MyMultipleCheckBoxState();
}

class _MyMultipleCheckBoxState extends State<MyMultipleCheckBox> {
  bool _Unnati = false;
  bool _Utkarsh = false;
  bool _Kavya = false;
  bool _Rihana = false;
  bool _Anni = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Checkbox'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Checkbox(
              value: _Unnati,
              onChanged: (value) {
                setState(() {
                  _Unnati = !_Unnati;
                });
              },
            ),
            const Text('Utkarsh'),
            //               bool _mohan = false;
            // bool _anuj = false;
            // bool _anshika = false;
            Checkbox(
              value: _deepak,
              onChanged: (value) {
                setState(() {
                  _deepak = !_deepak;
                });
              },
            ),
            const Text('Deepak'),
            Checkbox(
              value: _mohan,
              onChanged: (value) {
                setState(() {
                  _mohan = !_mohan;
                });
              },
            ),
            const Text('Mohan'),
            Checkbox(
              value: _anuj,
              onChanged: (value) {
                setState(() {
                  _anuj = !_anuj;
                });
              },
            ),
            const Text('Anuj'),
            Checkbox(
              value: _anshika,
              onChanged: (value) {
                setState(() {
                  _anshika = !_anshika;
                });
              },
            ),
            const Text('Anshika'),
          ],
        ),
      ),
    );
  }
}*/
