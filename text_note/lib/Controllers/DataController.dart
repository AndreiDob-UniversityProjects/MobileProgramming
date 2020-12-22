import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/Models/note.dart';
import 'package:todo_list/Models/operation.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:todo_list/Utils/rest_helper.dart';

class DataController {
  static DataController _dataController; // Singleton DataController
  RestHelper restHelper = RestHelper();
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool needToSync = false;
  //bool doesDbHaveDataFromServer = false;

  DataController._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DataController() {
    if (_dataController == null) {
      _dataController = DataController
          ._createInstance(); // This is executed only once, singleton object
    }
    return _dataController;
  }

  Future<int> insertNote(Note note) async {
    if (await isConnectedToInternet()) {
      //making sure the server is is sync with local db
      if (needToSync) {
        await executeOperations();
        needToSync = false;
      }
      //we have net, we save locally and on server
      await restHelper.insertNote(note);
      await databaseHelper.insertNote(note);
    } else {
      //we don't have net, we save locally, add to operation and set needToSync
      await databaseHelper.insertNote(note);
      databaseHelper.insertOperation(Operation("add", note));
      needToSync = true;
    }
  }

  // Update Operation: Update a note object and save it to database
  Future<int> updateNote(Note note) async {
    if (await isConnectedToInternet()) {
      //making sure the server is is sync with local db
      if (needToSync) {
        await executeOperations();
        needToSync = false;
      }
      //we have net, we save locally and on server
      await restHelper.updateNote(note);
      await databaseHelper.updateNote(note);
    } else {
      //we don't have net, we save locally, add to operation and set needToSync
      await databaseHelper.updateNote(note);
      databaseHelper.insertOperation(Operation("update", note));
      needToSync = true;
    }
  }

  // Delete Operation: Delete a note object from database
  Future<int> deleteNote(int id) async {
    if (await isConnectedToInternet()) {
      //making sure the server is is sync with local db
      if (needToSync) {
        await executeOperations();
        needToSync = false;
      }
      //we have net, we save locally and on server
      await restHelper.deleteNote(id);
      await databaseHelper.deleteNote(id);
    } else {
      //we don't have net, we save locally, add to operation and set needToSync
      await databaseHelper.deleteNote(id);
      databaseHelper.insertOperation(Operation("delete", Note.withId(id, "", "")));
      needToSync = true;
    }
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    //TODO save the doesDbHaveDataFromServer somewhere to be able to load from server only the first time ever

    //tests();
    //await setAppToDownloadFromServer();

    final prefs = await SharedPreferences.getInstance();

    if (await isConnectedToInternet()){
      if (needToSync) {
        await executeOperations();
        needToSync = false;
      }

      final bool doesDbHaveDataFromServer = prefs.getBool('doesDbHaveDataFromServer') ;//?? false;
      if (!doesDbHaveDataFromServer) {
        RestHelper rest = RestHelper();
        List<Note> notes = await rest.getNotes("/notes");
        //recreates the database to match the server
        databaseHelper.deleteAllNotes();
        for (var i = 0; i < notes.length; i++) {
          databaseHelper.insertNote(notes[i]);
        }
        //set not to download from server again
        prefs.setBool('doesDbHaveDataFromServer', true);
      }

      return await databaseHelper.getNoteList();;
    } else {
      return await databaseHelper.getNoteList();
    }
  }

  Future setAppToDownloadFromServer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('doesDbHaveDataFromServer', false);
  }

  Future tests() async {
    DatabaseHelper dbHelper=DatabaseHelper();
    await  dbHelper.initializeDatabase();

    await dbHelper.deleteAllOperations();
    await dbHelper.insertOperation(Operation("aaa1",Note("aa","bb")));
    await dbHelper.insertOperation(Operation("aaa2",Note("aa","bb")));
    await dbHelper.insertOperation(Operation("aaa3",Note("aa","bb")));

    List<Operation> opList=await dbHelper.getOperationList();

    await dbHelper.deleteAllOperations();

    opList=await dbHelper.getOperationList();

    var abc="";
  }

  Future executeOperations() async {
    List<Operation> operationList=await databaseHelper.getOperationList();
    for (var i = 0; i < operationList.length; i++) {
      if (operationList[i].type == "add") {
        await restHelper.insertNote(operationList[i].note);
      }
      if (operationList[i].type == "update") {
        await restHelper.updateNote(operationList[i].note);
      }
      if (operationList[i].type == "delete") {
        await restHelper.deleteNote(operationList[i].note.id);
      }
    }
    databaseHelper.deleteAllOperations();
  }

  Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
