import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class MyConnection extends StatefulWidget {
  const MyConnection({super.key});

  @override
  MyConnectionState createState() => MyConnectionState();
}

class MyConnectionState extends State<MyConnection> {
  bool connected = false;
  late Socket socket;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String message = "";
  TextEditingController name = TextEditingController(),
      port = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = '192.168.2.5';
    port.text = '3012';
    //  startConnection();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  //starting the connection and listening to the socket asynchronously
  void startConnection() async {
    print('attempting connection');
    //Instantiating the class with the Ip and the PortNumber
    try {
      int portnum = int.parse(port.text);
      socket = await Socket.connect(name.text, portnum);
      setState(() {
        connected = true;
      });
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      _streamSubscriptions.add(socket.listen(
        // handle data from the server
        (data) {
          final serverResponse = String.fromCharCodes(data);
          print('Server: $serverResponse');
          setState(() {
            message += "$serverResponse \n";
          });
        },

        // handle errors
        onError: (error) {
          print(error);
          socket.destroy();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          socket.destroy();
        },
      ));
      sendMessage("Hi from Flutter client");
    } on SocketException catch (error) {
      print(error);
    }
  }

  Future<void> sendMessage(String message) async {
    print('Client: $message');
    socket.writeln(message);
    //await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (connected)
            ? Center(
                child: Text("logger:\n $message"),
              )
            : Column(
                children: [
                  TextField(
                      controller: name, //captures the text, I think.
                      decoration:
                          const InputDecoration(helperText: "Enter Name")),
                  TextField(
                      controller: port,
                      decoration:
                          const InputDecoration(helperText: "Enter port")),
                  TextButton(
                      onPressed: startConnection, child: const Text('connect')),
                  Text("logger:\n $message"),
                ],
              ));
  }
}
