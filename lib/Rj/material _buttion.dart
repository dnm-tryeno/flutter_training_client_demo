import 'package:flutter/material.dart';

class RjMaterialButton extends StatelessWidget {
  const RjMaterialButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Material Button",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 113, 184, 241),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 4, 102, 182),
          title: const Text(
            "My Material Button",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 253)),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300.0,
                height: 60.0, // Adjusted height here
                child: MaterialButton(
                  color: Colors.red[400],
                  splashColor: Colors.yellow,
                  onPressed: () {},
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  shape: Border.all(color: Colors.black, width: 3.0),
                ),
              ),
              SizedBox(height: 20.0), // Added spacing between buttons
              SizedBox(
                width: 300.0,
                height: 60.0, // Adjusted height here
                child: MaterialButton(
                  color: Colors.red[400],
                  splashColor: Colors.yellow,
                  onPressed: () {},
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  shape: Border.all(color: Colors.black, width: 3.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
