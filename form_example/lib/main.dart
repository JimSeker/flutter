import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

//class MyApp extends StatelessWidget {
class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  TextEditingController nameController = TextEditingController();
  int _radioValue = 0;

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
      for(var num =0, x=1; num < 10; num++, x++) {

      }
      switch (_radioValue) {
        case 0:
          Fluttertoast.showToast(
              msg: 'Correct !', toastLength: Toast.LENGTH_SHORT);
          break;
        case 1:
          Fluttertoast.showToast(
              msg: 'Try again !', toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          Fluttertoast.showToast(
              msg: 'Try again !', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  void _fabPressed() {
    Fluttertoast.showToast(
        msg: 'You pressed the FAB', toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    Widget rowOne = Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: const [
          Text('Label: '),
          Text('Hello Form'),
        ]));

    Widget rowTwo = Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          const Text('Name: '),
          Flexible(
              //needed, for the renderer to figure out dynamic in a row, which is static.
              child: TextField(
            controller: nameController, //captures the text, I think.
            decoration: const InputDecoration(helperText: "Enter Name"),
          ))
        ]));
    Widget rowThree = Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: <Widget>[
          const Text('Raido Buttons?'),
          Radio(
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          const Text('Euro'),
          Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          const Text('Pound'),
          Radio(
            value: 2,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          const Text('Yen'),
        ]));

    Widget rowFour = Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          const Text('Button alert: '),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Alert!!', toastLength: Toast.LENGTH_SHORT);
              } else {
                Fluttertoast.showToast(
                    msg: 'Hi ${nameController.text}',
                    toastLength: Toast.LENGTH_SHORT);
              }
            },
            child: const Text('Toast!'),
          )
        ]));
    Widget rowFive = Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          const Text('Picture: '),
          Image.asset('images/phone.png', fit: BoxFit.cover)
        ]));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: Column(
          children: [
            rowOne,
            rowTwo,
            rowThree,
            rowFour,
            rowFive,
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _fabPressed,
          tooltip: 'Say hi',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
