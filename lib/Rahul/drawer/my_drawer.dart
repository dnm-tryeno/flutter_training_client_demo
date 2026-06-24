import 'package:flutter/material.dart';
import 'login_page.dart';
import 'contact.dart';

class MyDrawers extends StatefulWidget {
  const MyDrawers({Key? key}) : super(key: key);

  @override
  _MyDrawersState createState() => _MyDrawersState();
}

class _MyDrawersState extends State<MyDrawers> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Flutter Testing Page",
            ),
            accountEmail: const Text(
              "rahulmaurya@gmail.com",
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
                  "P",
                ),
                backgroundColor: Colors.white,
              )
            ],
            onDetailsPressed: () {},
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text(
              "Login",
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
              "Contact",
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ContactPages(),
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
