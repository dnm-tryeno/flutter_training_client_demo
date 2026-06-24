import 'package:flutter/material.dart';

void main() {
  runApp(W7D4Tooltip());
}

class W7D4Tooltip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Tooltip Example')),
        ),
        body: Center(
          child: Tooltip(
            message: 'This is a tooltip',
            child: IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Add your onPressed function here
              },
            ),
          ),
        ),
      ),
    );
  }
}
