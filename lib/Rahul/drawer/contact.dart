import 'package:flutter/material.dart';

import 'my_drawer.dart';

class ContactPages extends StatelessWidget {
  const ContactPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'flutter testing page';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        drawer: const MyDrawers(),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter user id',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your address',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 190, vertical: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () {},
            child: const Text('click me'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 170, vertical: 16),
          child: TextButton(
            onPressed: () {},
            child: const Text('Forget Password'),
          ),
        ),
      ],
    );
  }
}
