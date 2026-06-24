import 'package:flutter/material.dart';

import 'my_drawer.dart';

class Mydrawerapp extends StatelessWidget {
  const Mydrawerapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drawer',
        ),
      ),
      drawer: const MyDrawers(),
      body: const Center(
        child: FlutterLogo(
          size: 100.0,
        ),
      ),
    );
  }
}
