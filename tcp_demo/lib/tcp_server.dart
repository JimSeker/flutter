import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class MyServer extends StatefulWidget {
  const MyServer({super.key});

  @override
  MyServerState createState() => MyServerState();
}

class MyServerState extends State<MyServer> {
  bool connected = false;
  late Socket socket;
  late ServerSocket serverSocket;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String message = "";
  TextEditingController port = TextEditingController();

  @override
  void initState() {
    super.initState();
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

    //Instantiating the class with the Ip and the PortNumber
    try {
      int portnum = int.parse(port.text);
      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, portnum);
      // listen for clent connections to the server
      serverSocket.listen((client) {
        socket = client;
        print('Connection from'
            ' ${client.remoteAddress.address}:${client.remotePort}');

        setState(() {
          connected = true;
        });
        _streamSubscriptions.add(socket.listen(
          // handle data from the server
              (data) {
            final serverResponse = String.fromCharCodes(data);
            print('Server: $serverResponse');
            setState(() {
              message = serverResponse;
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
        //handleConnection(client);
      });
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
                child: Text("message is $message"),
              )
            : Column(
                children: [
                  TextField(
                      controller: port,
                      decoration:
                          const InputDecoration(helperText: "Enter port")),
                  TextButton(
                      onPressed: startConnection, child: const Text('Accept')),
                ],
              ));
  }
}
