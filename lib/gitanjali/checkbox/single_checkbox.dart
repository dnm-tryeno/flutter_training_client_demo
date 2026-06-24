import 'package:flutter/material.dart';

class SingleCheckBox extends StatelessWidget {
  const SingleCheckBox({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Create a Single Checkbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySingleCheckBox(),
    );
  }
}

class MySingleCheckBox extends StatefulWidget {
  const MySingleCheckBox({Key? key}) : super(key: key);
  //final String title;

  @override
  _MySingleCheckBoxState createState() => _MySingleCheckBoxState();
}

class _MySingleCheckBoxState extends State<MySingleCheckBox> {
  bool _checkbox = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: const Text('Create My Checkbox'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _checkbox,
                    onChanged: (value) {
                      setState(() {
                        _checkbox = !_checkbox;
                      });
                    },
                  ),
                  const Text('Are you agree with our conditions?'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
