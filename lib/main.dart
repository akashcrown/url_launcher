// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:get/get.dart' hide FormData;

void main(List<String> args) {
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  TextEditingController controller = TextEditingController();
  bool fetching = false;
  String text = 'your short  url will be appear here';
  getapi() async {
    setState(() {
      fetching = true;
    });
    try {
      var dio = Dio();
      var response = await dio.post(
        'https://url-shortener-service.p.rapidapi.com/shorten',
        data: FormData.fromMap(
          {
            'url': controller.text,
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'x-rapidapi-host': 'url-shortener-service.p.rapidapi.com',
            'x-rapidapi-key':
                'f9a8d228a2msh369a2a3d6cd5d35p1b38fajsnd44278523668',
          },
        ),
      );
      fetching = false;
      var result = response.data;
      setState(() {
        text = result['result_url'];
      });
    } catch (e) {
      fetching = false;
    }
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('url shortner'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter your url  ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  getapi();
                },
                child: Text('converter url'),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (fetching) CircularProgressIndicator()
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text.startsWith('http'))
              FloatingActionButton(
                onPressed: (() async {
                  await ClipboardManager.copyToClipBoard("$text");
                  Get.snackbar('SUCCESS ', 'URL copied',
                      snackPosition: SnackPosition.TOP);
                }),
                child: Icon(Icons.content_copy),
              ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                controller.text = '';
                text = '';
                setState(() {});
              },
              child: Icon(Icons.clear),
            )
          ],
        ),
      ),
    );
  }
}
