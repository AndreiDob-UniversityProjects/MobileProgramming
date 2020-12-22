import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:todo_list/Models/note.dart';

class RestHelper {
  static RestHelper _restHelper;

  RestHelper._createInstance();

  factory RestHelper() {
    if (_restHelper == null) {
      _restHelper = RestHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _restHelper;
  }

  Future<List<Note>> getNotes(String route) async {
    Response response = await get(_localhost() + "/notes");
    var decoded = json.decode(response.body);

    List<Note> noteList = List<Note>();
    for (int i = 0; i < decoded.length; i++) {
      noteList.add(Note.fromMapObject(decoded[i]));
    }
    return noteList;
  }

  Future<int> insertNote(Note note) async {
    Response response = await post(_localhost() + "/add",
        body: json.encode(note.toMap()),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        });
  }

  // Update Operation: Update a note object and save it to database
  Future<int> updateNote(Note note) async {
    Response response = await post(_localhost() + "/update",
        body: json.encode(note.toMap()),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        });
  }

  // Delete Operation: Delete a note object from database
  Future<int> deleteNote(int id) async {
    Response response = await post(_localhost() + "/delete",
        body: json.encode({"id": id}),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        });
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000';
    else // for iOS simulator
      return 'http://localhost:3000';
  }
}
