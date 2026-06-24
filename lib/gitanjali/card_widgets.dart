import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Card Example',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent[200],
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            ' Card Example',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 30,
            ),
          )),
        ),
      ),
      body: Center(
        child: Card(
          //  margin: EdgeInsets.only(right: 2),
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Thinking of You',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Just a little note to let you know that you\'re in my thoughts today. '
                  'I hope this card brings a smile to your face, just like your presence always brings '
                  'light to my life.\n\nWishing you all the happiness in the world.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
