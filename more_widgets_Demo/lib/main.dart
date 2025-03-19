import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'More Widgets Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownvalue = "Web"; //default value.
  bool switchvalue = false;
  double slidervalue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'DropDown value is : $dropdownvalue',
              ),
              DropdownButton(
                  items: const [
                    DropdownMenuItem(value: "Android", child: Text("Android")),
                    DropdownMenuItem(value: "IOS", child: Text("IOS")),
                    DropdownMenuItem(value: "Web", child: Text("Web")),
                    DropdownMenuItem(value: "Linux", child: Text("Linux"))
                  ],
                  value: dropdownvalue,
                  //uncomment to have the value shown as blank.
                  onChanged: (String? item) {
                    //or create method name(String ? item) {... } and call it here.
                    setState(() {
                      dropdownvalue = item!;
                    });
                  }),
              const Text('Switch Demo'),
              Switch(
                  value: switchvalue,
                  onChanged: (bool value) {
                    setState(() {
                      switchvalue = value;
                    });
                  }),
              Text('Slider value is $slidervalue'),
              Slider(
                value: slidervalue,
                onChanged: (newValue) {
                  setState(() {
                    slidervalue = newValue;
                  });
                },
                min: 0,
                max: 100,
                divisions: 10,
                label: "$slidervalue",
              ),
              const Text('a simple list with a snackbar'),
              Flexible(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      ListTile(
                        title: const Center(child: Text('Entry A')),
                        tileColor: Colors.blue,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You clicked A')),
                          );
                        },
                      ),
                      ListTile(
                        title: const Center(child: Text('Entry B')),
                        tileColor: Colors.green,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You clicked B')),
                          );
                        },
                      ),
                      ListTile(
                        tileColor: Colors.grey,
                        title: const Center(child: Text('Entry C')),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You clicked C')),
                          );
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}


