import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Text Button Example',
            style: TextStyle(
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              // Button Pressed
              print('Text Button Pressed');
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 20, horizontal: 35),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            child: Text('Press Me'),
          ),
        ),
      ),
    );
  }
}
