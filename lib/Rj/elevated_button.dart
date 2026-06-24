import 'package:flutter/material.dart';

class MYElevatedButtonRj extends StatelessWidget {
  const MYElevatedButtonRj({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    return MaterialApp(
        title: '',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              ' Elevated Button',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 120, 190, 247),
          body: Center(
            child: Wrap(
              // us can use horizontal or vertical
              direction: Axis.vertical,
              spacing: spacing,
              children: [
                const Text("Text Here ",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 25,
                    )),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Signup'),
                ),
              ],
            ),
          ),
        ));
  }
}
