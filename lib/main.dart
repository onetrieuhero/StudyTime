import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return new MaterialApp(
      theme: ThemeData(primaryColor: Colors.red[400]),
      home: new HomeScreen()
    );
  }
}

class HomeScreen extends StatelessWidget{
  Widget build(BuildContext context){
    theme: ThemeData(primaryColor: Colors.red[400]);
    return new Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Menu",
                style: TextStyle(fontSize: 30)),
              decoration: BoxDecoration(
                color: Colors.red[400],
              )
            ),
            ListTile(
              title: Text("Home",style: TextStyle(fontSize: 20)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomeScreen()));
              }
            ),
            ListTile(
              title: Text("To Do", style: TextStyle(fontSize: 20)),
              onTap:(){
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new TODO()));
              }
            )
          ]
        )
      )
    );
  }
}

class TODO extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
      ),
    );
  }
}

