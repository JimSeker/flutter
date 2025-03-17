import 'package:flutter/material.dart';
import 'package:navigation_drawer_demo/routes/routes.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key, required this.screen});
  final int screen ;
  @override
  DrawerWidgetState createState() => DrawerWidgetState(screenIndex: screen);
}

class DrawerWidgetState extends State<DrawerWidget> {
   DrawerWidgetState({required this.screenIndex});
  int screenIndex;

  void handleScreenChanged(int selectedScreen) {
    if (selectedScreen == 0) {
      screenIndex =0;
      Navigator.pushReplacementNamed(context, routes.first);
    } else if (selectedScreen == 1) {
      screenIndex =1;
      Navigator.pushReplacementNamed(context, routes.second);
    } else if (selectedScreen == 2) {
      screenIndex =2;
      Navigator.pushReplacementNamed(context, routes.third);
    } else if (selectedScreen == 3) {
      screenIndex =3;
      Navigator.pushReplacementNamed(context, routes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: handleScreenChanged,
      selectedIndex: screenIndex,
      children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.blueAccent],
              stops: [0.3, 1],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 90.0,
                height: 90.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/user.png'),
                  ),
                ),
              ),
              const Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.add_outlined),
          selectedIcon: Icon(Icons.add),
          label: const Text('First Screen'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.check_outlined),
          selectedIcon: Icon(Icons.check),
          label: Text('Second Screen'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.insert_emoticon),
          selectedIcon: Icon(Icons.insert_emoticon),
          label: Text('Third Screen'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home Screen'),
        ),
      ],
    );
  }
}
