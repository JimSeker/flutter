import 'dart:developer';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  bool _isSelected = false;
  bool _isFiltered = false;
  int inputs = 3;
  int? selectedIndex;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2025, 3, 7),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    setState(() {
      selectedDate = picked;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      //initialEntryMode: TimePickerEntryMode.input,
    );
    setState(() {
      selectedTime = picked;
    });
  }

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
            MenuAnchor(
              menuChildren: <Widget>[
                MenuItemButton(
                  child: Text('example1'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Example1 selected')),
                    );
                  },
                ),
                MenuItemButton(
                  child: Text('example2'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Example2 selected')),
                    );
                  },
                ),
                MenuItemButton(
                  child: Text('example3'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Example3 selected')),
                    );
                  },
                ),
              ],
              builder: (BuildContext context, MenuController controller, Widget? child) {
                return TextButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: Container(width: 250,height: 50, color: Colors.amber,
                    child: const Text("popup menu"),
                  ),
                );
              },
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List<Widget>.generate(inputs, (int index) {
                    return InputChip(
                      label: Text('Person ${index + 1}'),
                      selected: selectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selectedIndex == index) {
                            selectedIndex = null;
                          } else {
                            selectedIndex = index;
                          }
                        });
                      },
                      onDeleted: () {
                        setState(() {
                          inputs = inputs - 1;
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  inputs = 3;
                });
              },
              child: const Text('Reset'),
            ),
            ChoiceChip(
              label: Text('Choice Chip'),
              selected: _isSelected,
              onSelected: (bool selected) {
                // set state of the chip
                setState(() {
                  _isSelected = selected;
                });
              },
            ),
            FilterChip(
              label: Text('Filter Chip'),
              selected: _isFiltered,
              onSelected: (bool selected) {
                // set state of the chip
                setState(() {
                  _isFiltered = selected;
                });
              },
            ),
            ActionChip(
              label: Text('Action Chip'),
              onPressed: () {
                // Implement the action to be performed when the chip is pressed
                log('Action Chip pressed!');
              },
            ),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'No date selected',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            Text(
              selectedTime == null
                  ? 'No time selected'
                  : 'Selected Time: ${selectedTime!.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Select Time'),
            ),

            ElevatedButton(
              child: const Text('next Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoreUI()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoreUI extends StatefulWidget {
  const MoreUI({super.key});

  @override
  MoreUIState createState() => MoreUIState();
}

//class MyApp extends StatelessWidget {
class MoreUIState extends State<MoreUI> {
  // not a GlobalKey<MoreUIState>.
  final _formKey = GlobalKey<FormState>();
 int msgCount = 999;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = nameController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TextField demos"),
        actions: <Widget>[
          MenuAnchor(
            menuChildren: <Widget>[
              MenuItemButton(
                child: Text('example1'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Example1 selected')),
                  );
                },
              ),
              MenuItemButton(
                child: Text('example2'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Example2 selected')),
                  );
                },
              ),
              MenuItemButton(
                child: Text('example3'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Example3 selected')),
                  );
                },
              ),
            ],
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.blue,
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        key: _formKey,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter something',
                        ),
                        // update the state variable when the text changes
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (value.length < 4) {
                            return 'Please enter more than 4 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.purple,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                //Use the errorText function from above.
                errorText: _errorText,
              ),
              //As the user types, update the state variable,
              // triggering the errorText function
              onChanged: (text) => setState(() => nameController.text),
              onSubmitted: (text) {
                if (_errorText == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_errorText == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.brown,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Badge(
                    label: Text('Data'),
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.receipt),
                  ),
                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );},
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Badge.count(count: msgCount, child: const Icon(Icons.notifications)),
                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('lots of messages!')),
                  );
                  setState(() {
                    msgCount--;
                  });
                    },
                ),
              ],
            ),

            const Divider(
              height: 20,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.amber,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
