// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class RjButtonColumn extends StatelessWidget {
  const RjButtonColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 107, 184, 247),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Button With Column',
            style: TextStyle(
              fontSize: 20.0,
              color: Color.fromARGB(255, 241, 241, 239),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Text(
                  "First Text in Column",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: MaterialButton(
                  splashColor: Colors.cyan,
                  padding: const EdgeInsets.all(10.0),
                  onPressed: () {},
                  child: const Text(
                    "First Metarial Button",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                  "Sample Text",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
