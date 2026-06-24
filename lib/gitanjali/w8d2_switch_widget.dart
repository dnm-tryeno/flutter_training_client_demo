import 'package:flutter/material.dart';

void main() {
  runApp(W8D2SwitchWidget());
}

class W8D2SwitchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Switch Example",
      home: Scaffold(
        backgroundColor: Colors.lightGreen[100],
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Center(child: Text('Switch Widget Example')),
        ),
        body: Center(
          child: SwitchWidget(),
        ),
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _switchValue ? Icons.brightness_high : Icons.brightness_low,
          size: 60,
          color: _switchValue ? Colors.blue : Colors.grey,
        ),
        SizedBox(height: 30),
        Switch(
          value: _switchValue,
          onChanged: (newValue) {
            setState(() {
              _switchValue = newValue;
            });
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
