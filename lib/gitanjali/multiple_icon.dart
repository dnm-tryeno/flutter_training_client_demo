import 'package:flutter/material.dart';

class MultipleIcon extends StatelessWidget {
  const MultipleIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Multiple Icon Demo',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Multiple Icon Demo'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: Colors.pink,
                          size: 30.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.pink,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.pink,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.pink,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.pink,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.pink,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      minLines: 5, //Normal textInputField will be displayed
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: const <Widget>[
                //     Icon(
                //       Icons.contact_mail,
                //       color: Colors.pink,
                //       size: 10.0,
                //       semanticLabel: 'Text to announce in accessibility modes',
                //     ),
                //     Icon(
                //       Icons.mail_outlined,
                //       color: Colors.green,
                //       size: 60.0,
                //     ),
                //     Icon(
                //       Icons.phone_android,
                //       color: Colors.blue,
                //       size: 60.0,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}
