import 'package:flutter/material.dart';
//import 'package:flutter_training/Rb/button1.dart';

class Onof_fbutton extends StatelessWidget {
  const Onof_fbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter testing page",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Myhomepage(),
    );
  }
}

class Myhomepage extends StatefulWidget {
  const Myhomepage({Key? key}) : super(key: key);

  @override
  _MyhomepageState createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  bool _flag = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "flutter testing page",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 190, vertical: 16),
            child: ElevatedButton(
              onPressed: () => setState(() => _flag = !_flag),
              child: Text(_flag ? 'sell' : 'cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _flag ? Colors.teal : Colors.red, // This is what you need!
              ),
            ),
          ),
        ],
      ),
    );
  }
}
