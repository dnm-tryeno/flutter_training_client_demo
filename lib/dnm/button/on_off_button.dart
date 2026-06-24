import 'package:flutter/material.dart';
//import 'package:flutter_training/Rb/button1.dart';

class OnOffButton extends StatelessWidget {
  const OnOffButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "On Off Button",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _flag = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "On Off Button",
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
              child: Text(_flag ? 'On' : 'Off'),
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
