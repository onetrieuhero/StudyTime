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

class TODO extends StatefulWidget{
  @override
  _TODOState createState() => _TODOState();
}

class _TODOState extends State<TODO> {

  List<String> todoItems = [];

  void addItems(String task){
    if(task.length > 0){
      setState(() => todoItems.add(task));
    }
  }

  void removeItem(int index){
    setState(() => todoItems.removeAt(index));
  }

  void promptRemoveItem(int index){
    showDialog(context: context,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Mark "${todoItems[index]}" as done?'),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () => Navigator.of(context).pop()
          ),
          new FlatButton(
            child: new Text("Mark as done"),
            onPressed: (){
              removeItem(index);
              Navigator.of(context).pop();
            }
          )
        ]
      );
    });
  }

  Widget buildList(){
    return new ListView.builder(
      itemBuilder: (context, index){
        if(index < todoItems.length){
          return buildItems(todoItems[index], index);
        }
      },
    );
  }

  Widget buildItems(String text, int index){
    return new ListTile(
      title: new Text(text),
      onTap: () => promptRemoveItem(index)
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
      ),
      body: buildList(),
      floatingActionButton: FloatingActionButton(
          onPressed: addTodoScreen,
          tooltip: "Adding Task",
          child: Icon(Icons.add)
      )
    );
  }

  void addTodoScreen(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new Scaffold(
            appBar: new AppBar(
              title: Text("add a new task")
            ),
            body: new TextField(
              autofocus: true,
              onSubmitted: (val){
                addItems(val);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: "Enter Task",
              )
            )
          );
        }
      )
    );
  }
}

