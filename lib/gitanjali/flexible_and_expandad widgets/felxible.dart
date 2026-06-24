import 'package:flutter/material.dart';

void main() {
  runApp(FlexibleWidgets());
}

class FlexibleWidgets extends StatelessWidget {
  //@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flexible Example'),
        ),
        body: Column(
          children: [
            Container(
              height: 100,
              color: Colors.red,
              child: Center(child: Text('Fixed Height Container')),
            ),
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.blue,
                child: Center(child: Text('Flexible Container (Flex: 2)')),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.green,
                child: Center(child: Text('Flexible Container (Flex: 1)')),
              ),
            ),
            Container(
              height: 100,
              color: Colors.yellow,
              child: Center(child: Text('Fixed Height Container')),
            ),
          ],
        ),
      ),
    );
  }
}
