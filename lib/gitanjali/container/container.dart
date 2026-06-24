import 'package:flutter/material.dart';

class ContainerWidgets extends StatefulWidget {
  const ContainerWidgets({Key? key}) : super(key: key);

  @override
  _ContainerWidgetsState createState() => _ContainerWidgetsState();
}

class _ContainerWidgetsState extends State<ContainerWidgets> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "container page",
      home: Containerhomepage(),
    );
  }
}

class Containerhomepage extends StatefulWidget {
  const Containerhomepage({Key? key}) : super(key: key);

  @override
  _ContainerhomepageState createState() => _ContainerhomepageState();
}

class _ContainerhomepageState extends State<Containerhomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099a9),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            color: Colors.purpleAccent,
            margin: EdgeInsets.all(15.0),
            height: 30,
            width: 150,
            alignment: Alignment.center,
            child: Text("Start Row"),
          ),
          Row(
            //ROW 1
            children: [
              Container(
                child: Text(" Row 1"),
              ),
              Container(
                color: Colors.lime,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: FlutterLogo(
                  size: 50.0,
                ),
              ),
              Container(
                color: Colors.pinkAccent,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: FlutterLogo(
                  size: 50.0,
                ),
              ),
              Container(
                color: Colors.lime,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: FlutterLogo(
                  size: 50.0,
                ),
              ),
              Container(
                color: Colors.pinkAccent,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: FlutterLogo(
                  size: 50.0,
                ),
              ),
            ],
          ),
          Container(
            color: Colors.orangeAccent,
            margin: EdgeInsets.all(15.0),
            height: 30,
            width: 150,
            alignment: Alignment.center,
            child: Text(
              "Start Column",
            ),
          ),
          Container(
            color: Colors.green,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: FlutterLogo(
              size: 50.0,
            ),
          ),
          Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: FlutterLogo(
              size: 50.0,
            ),
          ),
          Container(
            color: Colors.green,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: FlutterLogo(
              size: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
