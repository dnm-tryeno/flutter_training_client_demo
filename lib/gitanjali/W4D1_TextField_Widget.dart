import 'package:flutter/material.dart';

class W4D1_textfield extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: Center(child: Text('TextField Example')),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your name ',
                    prefixIcon: Icon(Icons.person_outline_outlined, size: 30),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    
                    print('Input: $text');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone, size: 30),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    
                    print('Input: $text');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your personal details',
                    prefixIcon: Icon(Icons.person_outline_outlined, size: 30),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    
                    print('Input: $text');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Smile pls....',
                    prefixIcon: Icon(Icons.add_reaction_outlined, size: 30),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    
                    print('Input: $text');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: ' your favorite game',
                    prefixIcon: Icon(Icons.gamepad_rounded, size: 30),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    
                    print('Input: $text');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
