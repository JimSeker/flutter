import 'package:flutter/material.dart';

class DialogSlider extends StatefulWidget {
  @override
  DialogState createState() => DialogState();

  final double val;

  const DialogSlider({
    super.key,
    required this.val,
  });
}

class DialogState extends State<DialogSlider> {
  double value = 0;

  @override
  void initState() {
    super.initState();
    value = widget.val;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: (va) {
              setState(() {
                value = va;
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            // Pass the value you want to return here ---------------|
            onPressed: () => Navigator.pop(context, value), //<-----|
            child: const Text('confirm'),
          ),
        ],
      ),
    );
  }
}
