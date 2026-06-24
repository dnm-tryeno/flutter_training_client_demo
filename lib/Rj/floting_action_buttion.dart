import 'package:flutter/material.dart';

class RjFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Floating Action Button",
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 127, 201, 235),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 137, 94, 236),
        onPressed: () {
          print("Floatin Actio Button");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("My Floating Action Button"),
        // centerTitle: false,
        centerTitle: true,
      ),
    );
  }
}
