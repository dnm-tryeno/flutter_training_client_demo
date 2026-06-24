import 'package:flutter/material.dart';

class MyTabBar1 extends StatefulWidget {
  const MyTabBar1({Key? key}) : super(key: key);

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tab Bar',
      home: MyTabBarPage(),
    );
  }
}

class MyTabBarPage extends StatefulWidget {
  const MyTabBarPage({Key? key}) : super(key: key);

  @override
  _MyTabBarPageState createState() => _MyTabBarPageState();
}

class _MyTabBarPageState extends State<MyTabBarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            //isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.settings)),
              Tab(icon: Icon(Icons.search)),
            ],
          ),
          title: Text('Tabs Example'),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.chat, size: 200),
            Icon(Icons.home, size: 200),
            Icon(Icons.settings, size: 200),
            Icon(Icons.search, size: 200),
          ],
        ),
      ),
    );
  }
}
