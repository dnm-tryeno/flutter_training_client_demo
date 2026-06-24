import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    return MaterialApp(
        title: 'Welcome to Text Button',
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Welcome to My Elevated Button',
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          ),
          body: Center(
            child: Wrap(
              // us can use horizontal or vertical
              direction: Axis.vertical,
              spacing: spacing,
              children: [
                const Text(
                  "Text Here",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 15,
                      )),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}


