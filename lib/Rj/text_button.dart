import 'package:flutter/material.dart';

class TextButtonRj extends StatelessWidget {
  const TextButtonRj({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Text Button',
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 86, 160, 221),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 69, 8, 238),
            title: const Text('Welcome to text'),
          ),
          body: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 20,
              children: [
                const Text(
                  "Text Here ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Disabled'),
                ),
              ],
            ),
          ),
        ));
  }
}
