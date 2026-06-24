import 'package:flutter/material.dart';
import 'package:flutter_application_1/Rb/radio%20button/radiorow.dart';

void main() {
  runApp(StackWidget());
}

class StackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Stack Widget Example'),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                width: 300,
                height: 300,
                color: Colors.blue,
              ),
              Positioned(
                top: 50,
                left: 50,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
              ),
              Positioned(
                bottom: 50,
                right: 50,
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.green,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.yellow.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      'Hello Stack!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
