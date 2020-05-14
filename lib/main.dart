import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());
List<String> todoItems = [];

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context){
    return new MaterialApp(
      theme: ThemeData(primaryColor: Colors.redAccent[100],),
      home: new HomeScreen()
    );
  }
}

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context){

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
                color: Colors.redAccent[100],
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
      ),
        body: Builder(builder: (context) => Container(
          alignment: Alignment.center,
          child: FittedBox(
              child: TimerWidget()
          ),
        ))
    );
  }
}

class TimerWidget extends StatefulWidget{

  final Duration duration = Duration(minutes: 25);
  final Duration tick = Duration(milliseconds: 250);


  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>{
  SnackBar _breakTime = SnackBar(content: Text("Break Time"));

  Timer _timer;
  Duration _duration = Duration(minutes: 25);
  Duration _tick;

  Duration _countDown = Duration(minutes: 25);
  DateTime _endTime;
  String _btext = "Start";
  String _displayTime= "25:00";

  void initState(){
    setState((){

      _duration = widget.duration ?? Duration(minutes: 25);
      _tick = widget.tick ?? Duration(milliseconds: 250);

    });
    super.initState();
  }

  String displayTime(Duration time){
    int min = time.inMinutes;
    int sec = (time.inSeconds - (time.inMinutes * 60));
    return '$min:${sec.toString().padLeft(2,"0")}';
  }

  void startTime(BuildContext context){
    setState((){
      _endTime = DateTime.now().add(_duration);
      _displayTime = displayTime(_duration - _tick);

      _btext = "Stop";
      _timer = Timer.periodic(_tick, (Timer timer){
        setState((){
          _countDown = _endTime.difference(DateTime.now());
          _displayTime = displayTime(_countDown);


          if(DateTime.now().isAfter(_endTime)){
            stopTime();
            Scaffold.of(context).showSnackBar(_breakTime);
          }
        });
      });
    });
  }

  void stopTime() => setState(() {
    _btext = "Reset";
    _timer.cancel();
  });

  void resetTime() => setState((){
    _countDown = _duration;
    _displayTime = displayTime(_countDown);
    _btext = "Start";
  });

  void buttonPress(BuildContext context){
    if(_timer?.isActive ?? false){
      stopTime();
    }else{
      if(_countDown == _duration){
        startTime(context);
      }else{
        resetTime();

      }
    }
  }



  Widget build(BuildContext context){
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
          height: 200,
          width: 200,
          child: CircularProgressIndicator(
            value: _countDown.inMilliseconds / _duration.inMilliseconds,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red[200]),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text(_displayTime, style: TextStyle(fontSize: 30)),
            ]),
            FlatButton(
              color: Colors.redAccent[100],
              child: Text(_btext),
              shape:StadiumBorder(),
              onPressed: () => buttonPress(context),
            )

          ],

        ),
      ]
    );
  }
}


class TODO extends StatefulWidget{
  @override
  _TODOState createState() => _TODOState();
}

class _TODOState extends State<TODO> {



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
      title: new Text(text, style: TextStyle(decoration: TextDecoration.underline, fontSize: 25)),
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


