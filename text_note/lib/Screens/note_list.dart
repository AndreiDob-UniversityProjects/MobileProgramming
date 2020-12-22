import 'dart:async';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Controllers/DataController.dart';
import 'package:todo_list/Models/note.dart';
import 'package:todo_list/Screens/note_detail.dart';
import 'package:todo_list/Utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> with TickerProviderStateMixin {
  DataController dataController = DataController();
  List<Note> noteList;
  Color color = Colors.black;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return new FutureBuilder(
        future: getBackgroundColor(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return Scaffold(
              appBar: new AppBar(
                  title: new Text('Notes',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold))),
              body: AnimatedBackground(
                  behaviour:RacingLinesBehaviour(),
                  vsync: this,
                  child: getNoteListView(snapshot.data)),
              drawer: getDrawer(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  debugPrint('FAB clicked');
                  navigateToDetail(Note('', '', ''), 'Add Note');
                },
                tooltip: 'Add Note',
                child: Icon(Icons.add),
              ),
            );
          } else {
            return new Text('No color in preferences');
          }
        });
  }

  ListView getNoteListView(Color color) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: color,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.noteList[position].title,
                style: TextStyle(fontSize: 25.0, color: Colors.cyan[100])),
            subtitle: Text(this.noteList[position].description,
                style: TextStyle(fontSize: 20.0)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    _delete(context, noteList[position]); //for delete
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Note note) async {
    int result = await dataController.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

//this is used to print messages to screen
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture =
        dataController.databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataController.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  static Future<Color> getBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();

    String color = prefs.getString('color');
    if (color == "black") {
      return Colors.black;
    }
    if (color == "blue") {
      return Colors.blueGrey;
    }
    if (color == "green") {
      return Colors.green;
    }
  }

  Drawer getDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Select note color'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Black'),
            onTap: () async {
              // Update the state of the app
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('color', "black");
              setState(() {
                this.color = Colors.black;
              });
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Blue'),
            onTap: () async {
              // Update the state of the app
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('color', "blue");
              setState(() {
                this.color = Colors.blueGrey;
              });
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Green'),
            onTap: () async {
              // Update the state of the app
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('color', "green");
              setState(() {
                this.color = Colors.green;
              });
              // Then close the drawer
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
