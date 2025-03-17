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
      home: const MyHomePage(title: 'Rail or Bar Demo'),
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
  late bool showNavigationRail;

  int selectedIndex = 0;
  final List<NavigationRailDestination> destinationsRail = [
    NavigationRailDestination(
      icon: const Icon(Icons.flight_outlined),
      selectedIcon: const Icon(Icons.flight),
      label: Text('Flight'),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.directions_bike_outlined),
      selectedIcon: const Icon(Icons.directions_bike),
      label: Text('bike'),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.directions_boat_outlined),
      selectedIcon: const Icon(Icons.directions_boat),
      label: Text('boat'),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.directions_bus_outlined),
      selectedIcon: const Icon(Icons.directions_bus),
      label: Text('bus'),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.directions_car_outlined),
      selectedIcon: const Icon(Icons.directions_car),
      label: Text('car'),
    ),
  ];

  final List<NavigationDestination> destinationsBar = const <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.flight), label: 'flight'),
    NavigationDestination(icon: Icon(Icons.directions_bike), label: 'bike'),
    NavigationDestination(icon: Icon(Icons.directions_boat), label: 'boat'),
    NavigationDestination(icon: Icon(Icons.directions_bus), label: 'bus'),
    NavigationDestination(icon: Icon(Icons.directions_car), label: 'car'),
  ];

  final List<Icon> icons = const [
    Icon(Icons.flight, size: 350),
    Icon(Icons.directions_bike, size: 350),
    Icon(Icons.directions_boat, size: 350),
    Icon(Icons.directions_bus, size: 350),
    Icon(Icons.directions_car, size: 350),
  ];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationRail = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationRail ? buildRailScaffold(context) : buildBarScaffold();
  }

  /// This will build the code for NavigationRail, which called above if the screen
  /// is wider than 450 pixels.
 buildRailScaffold (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            elevation: 5,
            useIndicator: true,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: destinationsRail,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: buildMainWidget(selectedIndex)
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  buildBarScaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: buildMainWidget(selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: destinationsBar,
        selectedIndex: selectedIndex,
        indicatorColor: Colors.blue,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget buildMainWidget(int selectedIndex) {
    return Center(
      child: icons[selectedIndex],
    );
  }

}
