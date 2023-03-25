import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

class MyServer extends StatefulWidget {
  const MyServer({super.key});

  @override
  MyServerState createState() => MyServerState();
}

class MyServerState extends State<MyServer> {
  bool connected = false;
  late Socket socket;
  late ServerSocket serverSocket;
  var myAddress;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String message = "";
  TextEditingController port = TextEditingController();
  TextEditingController msg = TextEditingController();

  @override
  void initState() {
    super.initState();
    port.text = '3012';
    //  startConnection();
    getinfo();
  }

  Future<void> getinfo() async {
    List<NetworkInterface> address = await NetworkInterface.list(
      includeLoopback: false,
    );
    for (var element in address) {
      for (var element in element.addresses) {
        setState(() {
          message += "$element.address\n";
        });
      }
    }
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
        developer.log(
            'Connection from  ${client.remoteAddress.address}:${client.remotePort}');
        setState(() {
          connected = true;
        });
        _streamSubscriptions.add(socket.listen(
          // handle data from the server
          (data) {
            final serverResponse = String.fromCharCodes(data);

            developer.log('Server: $serverResponse');
            setState(() {
              message += "Received: $serverResponse\n";
            });
          },

          // handle errors
          onError: (error) {
            developer.log("onError", error: error);
            socket.destroy();
            setState(() {
              message += "ERROR\n";
              connected = false;
            });
          },

          // handle server ending connection
          onDone: () {
            developer.log('Client left.');
            setState(() {
              connected = false;
              message += "Client closed the connection\n";
            });
            socket.destroy();
          },
        ));
        //handleConnection(client);
      });
    } on SocketException catch (error) {
      developer.log("SocketException", error: error);
    }
  }

  Future<void> sendMessage(String message) async {
    developer.log('Client: $message');
    socket.writeln(message);
    setState(() {
      message += "SENT: $message\n";
    });
    //await Future.delayed(Duration(seconds: 2));
  }

  void send() {
    if (msg.text != "") {
      sendMessage(msg.text);
    }
  }

  void closeConnection() {
    socket.destroy();
    setState(() {
      connected = false;
      message += "Server closed socket.\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (connected)
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                      controller: msg,
                      decoration: const InputDecoration(
                          helperText: "Enter message to send")),
                  TextButton(onPressed: send, child: const Text('Send')),
                  TextButton(
                      onPressed: closeConnection, child: const Text('close')),
                  Text("Logger:\n $message"),
                ],
              )
            : Column(
                children: [
                  TextField(
                      controller: port,
                      decoration:
                          const InputDecoration(helperText: "Enter port")),
                  TextButton(
                      onPressed: startConnection, child: const Text('Accept')),
                  Text("Logger:\n $message"),
                ],
              ));
  }
}
