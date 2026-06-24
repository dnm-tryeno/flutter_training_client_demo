import 'package:flutter/material.dart';

class W3D4_text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightGreen[10],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          title: Center(child: Text('Text Widget Example')),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello, World!',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'MYSELF GITANJALI RAI',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.pinkAccent[200],
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              Text(
                'This is the Text Widget!',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[200],
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
