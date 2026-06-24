import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RowAndColumnPage extends StatelessWidget {
  const RowAndColumnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.deepOrangeAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.yellow,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.deepOrangeAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.yellow,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.deepOrangeAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.yellow,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.orangeAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        child: Icon(Icons.star),
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.pink,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.green,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.pink,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.green,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.pink,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.green,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.pink,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.green,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.red,
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        color: Colors.blueAccent,
                      ),
                    ],
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
