import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

///This is the client side of the code.  It takes an ip address and port number
///once entered (there are default values), you can connect to the server side
///of this or use something like an echo server or any server, since it you can
///then send messages of your crafting.   When done, close the socket.

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
  TextEditingController name = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController msg = TextEditingController();

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
        'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}',
      );

      _streamSubscriptions.add(
        socket.listen(
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
            setState(() {
              message += "ERROR\n";
              connected = false;
            });
          },

          // handle server ending connection
          onDone: () {
            developer.log('Server left.');
            setState(() {
              connected = false;
              message += "Server closed the connection\n";
            });
            socket.destroy();
          },
        ),
      );
      sendMessage("Hi from Flutter client");
    } on SocketException catch (error) {
      developer.log("SocketException", error: error);
    }
  }

  void sendMessage(String message) {
    developer.log('Client: $message');
    socket.writeln(message);
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
      message += "client closed socket.\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          (connected)
              ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: msg,
                    decoration: const InputDecoration(
                      helperText: "Enter message to send",
                    ),
                  ),
                  TextButton(onPressed: send, child: const Text('Send')),
                  TextButton(
                    onPressed: closeConnection,
                    child: const Text('close'),
                  ),
                  Text("Logger:\n $message"),
                ],
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(helperText: "Enter Name"),
                  ),
                  TextField(
                    controller: port,
                    decoration: const InputDecoration(helperText: "Enter port"),
                  ),
                  TextButton(
                    onPressed: startConnection,
                    child: const Text('connect'),
                  ),
                  Text("logger:\n $message"),
                ],
              ),
    );
  }
}
