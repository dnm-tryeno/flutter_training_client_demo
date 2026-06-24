import 'package:flutter/material.dart';

class W3D1_Scaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Scaffold Example')),
      ),
      body: Center(
        child: Text('Hello, Scaffold!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed logic here
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[200],
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                iconSize: 30,
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                iconSize: 30,
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                iconSize: 30,
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              IconButton(
                icon: Icon(Icons.message),
                iconSize: 30,
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              IconButton(
                icon: Icon(Icons.call),
                iconSize: 30,
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
