import 'package:flutter/material.dart';

void main() {
  runApp(RadioButton());
}

class RadioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Center(child: Text('Radio Button Example')),
        ),
        body: Center(
          child: RadioButtonWidget(),
        ),
      ),
    );
  }
}

class RadioButtonWidget extends StatefulWidget {
  @override
  _RadioButtonWidgetState createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  String selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RadioListTile(
          title: Text('Option 1'),
          value: 'Option 1',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('Option 2'),
          value: 'Option 2',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('Option 3'),
          value: 'Option 3',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value.toString();
            });
          },
        ),
        Text(
          'Selected value: $selectedValue',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
