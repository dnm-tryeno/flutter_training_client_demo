import 'package:flutter/material.dart';

class W8D2ChildScrollView extends StatelessWidget {
  const W8D2ChildScrollView({super.key});

  static const String _title = 'SingleChildScrollView Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            // SingleChildScrollView widget
            scrollDirection: Axis.vertical, // Scroll direction (vertical)
            reverse: false, // Whether the scroll view is reversed or not
            padding: const EdgeInsets.all(16.0), // Padding around the content
            physics: const BouncingScrollPhysics(), // Scrolling physics
            controller: ScrollController(), // Scroll controller
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    // First container with fixed height
                    color: const Color(0xffeeee00), // Yellow color
                    height: 200.0, // Fixed height
                    alignment: Alignment.center,
                    child: const Text('Container 1'), // Text inside the container
                  ),
                  Container(
                    // Second container with fixed height
                    color: const Color(0xff008000), // Green color
                    height: 200.0, // Fixed height
                    alignment: Alignment.center,
                    child: const Text('Container 2'), // Text inside the container
                  ),
                  // Add more containers or widgets here if needed
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
