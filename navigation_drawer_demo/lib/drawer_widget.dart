import 'package:flutter/material.dart';
import 'package:navigation_drawer_demo/routes/routes.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [ Colors.white,Colors.blueAccent],
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
                          image: AssetImage('images/user.png')
                      )
                  ),
                ),
                const Text('User',style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('First Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.pop(context);  //closes the drawer, now change screens.
              Navigator.pushReplacementNamed(context, routes.first);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check),
            title: const Text('Second Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap:  (){
              Navigator.pop(context);  //closes the drawer, now change screens.
              Navigator.pushReplacementNamed(context, routes.second);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_emoticon),
            title:const Text('Third Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap:  (){
              Navigator.pop(context);  //closes the drawer, now change screens.
              Navigator.pushReplacementNamed(context, routes.third);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:const Text('Home Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap:  (){
              Navigator.pop(context);  //just closes the drawer.
              Navigator.pushReplacementNamed(context, routes.main);
            },
          )
        ],
      ),
    );
  }
}
