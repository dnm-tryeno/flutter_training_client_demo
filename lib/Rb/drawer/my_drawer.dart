import 'package:flutter/material.dart';
import 'login_page.dart';
import 'contact.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              "flutter testing page",
            ),
            accountEmail: const Text(
              "707abcd@gmail.com",
            ),
            currentAccountPicture: const CircleAvatar(
              child: Text(
                "R",
              ),
              backgroundColor: Colors.white,
            ),
            otherAccountsPictures: const <Widget>[
              CircleAvatar(
                child: Text(
                  "p",
                ),
                backgroundColor: Colors.white,
              )
            ],
            onDetailsPressed: () {},
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text(
              "login",
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text(
              "contact",
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ContactPage(),
                ),
              );
            },
          ),
          const Divider()
        ],
      ),
    );
  }
}
