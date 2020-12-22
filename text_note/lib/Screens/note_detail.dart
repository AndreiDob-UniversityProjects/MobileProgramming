import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/Controllers/DataController.dart';
import 'package:todo_list/Models/note.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note todo;

  NoteDetail(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.todo, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DataController dataController = DataController();

  String appBarTitle;
  Note todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: getButtons(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> getButtons() {
    List<Widget> buttons = List();
    buttons.add(Expanded(
      child: RaisedButton(
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        child: Text(
          'Save',
          textScaleFactor: 1.5,
        ),
        onPressed: () {
          setState(() {
            debugPrint("Save button clicked");
            _save();
          });
        },
      ),
    ));

    buttons.add(
      Container(
        width: 5.0,
      ),
    );

    // if we are updating an element
    if (todo.id != null) {
      buttons.add(Expanded(
        child: RaisedButton(
          color: Theme.of(context).primaryColorDark,
          textColor: Theme.of(context).primaryColorLight,
          child: Text(
            'Delete',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            setState(() {
              debugPrint("Delete button clicked");
              _delete();
            });
          },
        ),
      ));
    }

    return buttons;
  }

  void moveToLastScreen() {
    //here you set the result retriefed in note_list
    Navigator.pop(context, true);
  }

  // Update the title of note object
  void updateTitle() {
    todo.title = titleController.text;
  }

  // Update the description of note object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await dataController.updateNote(todo);
    } else {
      // Case 2: Insert Operation
      result = await dataController.insertNote(todo);
    }

//    if (result != 0) {
//      // Success
//      _showAlertDialog('Status', 'Note Saved Successfully');
//    } else {
//      // Failure
//      _showAlertDialog('Status', 'Problem Saving Note');
//    }
  }

  void _delete() async {
    moveToLastScreen();

    int result = await dataController.deleteNote(todo.id);

//    if (result != 0) {
//      _showAlertDialog('Status', 'Note Deleted Successfully');
//    } else {
//      _showAlertDialog('Status', 'Error Occured while Deleting Note');
//    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
