import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MainProvider extends ChangeNotifier {
  final url = "172.20.10.7";
  final port = 4550;

  late Socket socket;

  MainProvider() {
    Socket.connect(url, port).then((Socket sock) {
      socket = sock;
      socket.listen(_dataHandler,
          onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
    });
  }

  void _dataHandler(data) {
    print(String.fromCharCodes(data).trim());
  }

  void _errorHandler(error, StackTrace trace) {
    print(error);
  }

  void _doneHandler() {
    socket.destroy();
  }

  void sendData() {
    socket.write("hello there");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MainProvider(),
        child: Consumer<MainProvider>(
            builder: (context, provider, child) => MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: Scaffold(
                    body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("hello"),
                      GestureDetector(
                          onTap: () => provider.sendData(),
                          child: Container(
                              width: 100, height: 50, color: Colors.red))
                    ],
                  ),
                )))));
  }
}
