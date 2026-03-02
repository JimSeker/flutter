import 'package:flutter/material.dart';

class DialogExample extends StatefulWidget {
  @override
  DialogState createState() => DialogState();

  final Function(String one, String two) onConfirm;

  const DialogExample({
    super.key,
    required this.onConfirm,
  });
}

class DialogState extends State<DialogExample> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String input1 = "";
  String input2 = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Name"),
      content: Column(children: [
        TextFormField(
          controller: _controller1,
        ),
        TextFormField(
          controller: _controller2,
        )
      ]),
      actions: <Widget>[
        TextButton(
          onPressed: () {
           // widget.onConfirm("",""); // cancelled, don't call method.
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm(_controller1.text,_controller2.text);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
