import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:navigation_drawer_demo/first_screen.dart';
import 'package:navigation_drawer_demo/second_screen.dart';
import 'package:navigation_drawer_demo/third_screen.dart';

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
                Text('User',style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('First Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.pop(context);  //closes the drawer, now change screens.
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FirstScreen()
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.check),
            title: const Text('Second Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap:  (){
              Navigator.pop(context);  //closes the drawer, now change screens.
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SecondScreen()
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_emoticon),
            title:const Text('Third Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap:  (){
              Navigator.pop(context);  //closes the drawer, now change screens.
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ThirdScreen()
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:const Text('Home Screen',style: TextStyle(fontWeight: FontWeight.bold),),
            onTap:  (){
              Navigator.pop(context);  //just closes the drawer.
            },
          )
        ],
      ),
    );
  }
}
