// import 'package:flutter/material.dart';
// import 'dart:async';

// // class VisibilityExample extends StatefulWidget {
// //   @override
// //   _VisibilityExampleState createState() {
// //     return _VisibilityExampleState();
// //   }
// // }

// // class _VisibilityExampleState extends State {
// //   bool _isVisible = true;

// //   void showToast() {
// //     setState(() {
// //       _isVisible = !_isVisible;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Visibility Example',
// //       home: Scaffold(
// //           appBar: AppBar(
// //             title: Center(child: Text('Visibility Example')),
// //           ),
// //           body: Padding(
// //             padding: EdgeInsets.all(15.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 ElevatedButton(
// //                   child: Text('Show/Hide Card B'),
// //                   onPressed: showToast,
// //                 ),
// //                 Card(
// //                   child: new ListTile(
// //                     title: Center(
// //                       child: new Text('A'),
// //                     ),
// //                   ),
// //                 ),
// //                 Visibility(
// //                   visible: _isVisible,
// //                   child: Card(
// //                     child: new ListTile(
// //                       title: Center(
// //                         child: new Text('B'),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Card(
// //                   child: new ListTile(
// //                     title: Center(
// //                       child: new Text('C'),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           )),
// //     );
// //   }
// // }

// class FlutterDelayWidgetDemo extends StatefulWidget {
//   const FlutterDelayWidgetDemo({Key? key}) : super(key: key);
//   @override
//   State<FlutterDelayWidgetDemo> createState() => _FlutterDelayWidgetDemoState();
// }

// class _FlutterDelayWidgetDemoState extends State<FlutterDelayWidgetDemo> {
//   bool _isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     // 1. Using Timer
//     Timer(Duration(seconds: 6), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
// // 2. Future.delayed
//     Future.delayed(Duration(seconds: 6), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Delay Widget",
//       home: Scaffold(
//         appBar: AppBar(
//           title: Center(child: Text('Visibility Example')),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               if (_isLoading) ...[
//                 Card(
//                   child: Column(
//                     children: <Widget>[
//                       const ListTile(
//                         leading: Icon(Icons.access_alarm),
//                         title: Text('Welcome To My Timeline'),
//                         subtitle: Text(
//                             'My time line is for sudsy for you and your fairly'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: <Widget>[
//                           TextButton(
//                             child: const Text('BUY TICKETS'),
//                             onPressed: () {/* ... */},
//                           ),
//                           const SizedBox(width: 8),
//                           TextButton(
//                             child: const Text('LISTEN'),
//                             onPressed: () {/* ... */},
//                           ),
//                           const SizedBox(width: 8),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ] else ...[
//                 Container(
//                     color: Colors.grey,
//                     height: 100,
//                     width: 250,
//                     child: Center(
//                       child: Text(
//                         "Expired!!",
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.red,
//                         ),
//                       ),
//                     )),
//               ],
//               const SizedBox(
//                 height: 50,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
