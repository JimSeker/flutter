import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

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
    developer.log('attempting connection');
    //Instantiating the class with the Ip and the PortNumber
    try {
      int portnum = int.parse(port.text);
      socket = await Socket.connect(name.text, portnum);
      setState(() {
        connected = true;
      });
      developer.log(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      _streamSubscriptions.add(socket.listen(
        // handle data from the server
        (data) {
          final serverResponse = String.fromCharCodes(data);
          developer.log('Server: $serverResponse');
          setState(() {
            message += "$serverResponse \n";
          });
        },

        // handle errors
        onError: (error) {
          developer.log(error);
          socket.destroy();
        },

        // handle server ending connection
        onDone: () {
          developer.log('Server left.');
          socket.destroy();
        },
      ));
      sendMessage("Hi from Flutter client");
    } on SocketException catch (error) {
      developer.log("SocketException", error: error);
    }
  }

  Future<void> sendMessage(String message) async {
    developer.log('Client: $message');
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
