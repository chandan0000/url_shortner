import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("shorten URL"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter your url here',
                hintText: 'http://www.example.com',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 8,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  final shortendedUrl = await shortenUrl(url: controller.text);
                  if (shortendedUrl != null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Url Shortened Successfulluy'),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (await canLaunch(shortendedUrl)) {
                                            await launch(shortendedUrl);
                                          }
                                        },
                                        child: Container(
                                          color: Colors.grey.withOpacity(.2),
                                          child: Text(shortendedUrl),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: shortendedUrl))
                                                .then((value) => ScaffoldMessenger
                                                        .of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Url is copies to the clipboard'))));
                                          },
                                          icon: Icon(Icons.copy))
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      controller.clear();
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close),
                                    label: Text('Close'),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
                child: Text('Url Short'))
          ],
        ),
      ),
    );
  }

  Future<String?> shortenUrl({required String url}) async {
    try {
      final result = await http.post(
          Uri.parse('https://cleanuri.com/api/v1/shorten'),
          body: {'Uri': url});
      if (result.statusCode == 200) {
        final jsonResult = jsonDecode(result.body);
      }
    } catch (e) {
      print('Error ${e.toString()}');
    }
    return null;
  }
}
