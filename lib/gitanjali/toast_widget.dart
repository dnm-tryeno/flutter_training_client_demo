import 'package:flutter/material.dart';

void main() {
  runApp(ToastApp());
}

class ToastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Center(child: Text('Simple Toast Example')),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showToast(context, 'Hello, this is a toast!');
            },
            child: Text('Show Toast'),
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
