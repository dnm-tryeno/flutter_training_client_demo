// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// //import 'package:flutter_application_1/chatpage.dart';
// //import 'package:stream_chat_flutter.stream_chat_flutter.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Future<void> main() async {
//   const apiKey = "3qgu8txazfuj";
//   const userToken =
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiUkJNQVVSWUEifQ.ErZxRoOstvxtRAxxwPHw4vbX8No1pK8e2jv5vbORuhc";
//   final client = StreamChatClient(
//     apiKey,
//     logLevel: Level.INFO,
//   );
//   await client.connectUser(
//     User(
//       id: 'RBMAURYA',
//       extraData: const {
//         'image': 'https://robertbrunhage.come/logo.png',
//       },
//     ),
//     userToken,
//   );
//   final channel = client.channel(
//     'messageing',
//     id: 'coolkids',
//     extraData: const {
//       "name": "cool Kids",
//       "images": "https://robertbrunhage.com/logo.png",
//     },
//   );
//   channel.watch();

//   runApp(MyApp(client, channel));
// }

// class MyApp extends StatelessWidget {
//   //const MyApp({Key? key}) : super(key: key);

//   final StreamChatClient client;
//   final Channel channel;
//   const MyApp(this.client, this.channel, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = ThemeData.dark().copyWith(
//       //accentColor: Color(Bxffc34c4c),
//       colorScheme:
//           ColorScheme.fromSwatch().copyWith(secondary: Colors.amberAccent),
//     );
//     return MaterialApp(
//       builder: (context, widget) {
//         return StreamChat(
//           client: client,
//           child: widget,
//           streamChatThemeData: StreamChatThemeData.fromTheme(theme),
//         );
//       },
//       home: StreamChannel(
//         channel: channel,
//         child: const ChannelPage(),
//       ),
//     );
//   }
// }

// class ChannelPage extends StatelessWidget {
//   const ChannelPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const ChannelHeader(
//         showBackButton: false,
//       ),
//       body: Column(
//         children: const <Widget>[
//           Expanded(
//             child: MessageListView(),
//           ),
//           MessageInput(),
//         ],
//       ),
//     );
//   }
// }
