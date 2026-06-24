import 'package:flutter/material.dart';

class MyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '  ListView Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My List'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.music_off),
              title: Text(
                'Music',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(
                'Album',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                'Phone',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.browse_gallery_outlined),
              title: Text(
                'Gallary',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text(
                'Camera',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Setting',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.photo_sharp),
              title: Text(
                'Photos',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.videogame_asset),
              title: Text(
                'Video Game',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
