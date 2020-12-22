import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_list/Models/note.dart';
import 'package:todo_list/Models/operation.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:todo_list/Utils/rest_helper.dart';

Future main() async {
//  DatabaseHelper dbHelper=DatabaseHelper();
//  await  dbHelper.initializeDatabase();
//
//  await dbHelper.deleteAllOperations();
//  await dbHelper.insertOperation(Operation("aaa1",Note("aa","bb")));
//  await dbHelper.insertOperation(Operation("aaa2",Note("aa","bb")));
//  await dbHelper.insertOperation(Operation("aaa3",Note("aa","bb")));
//
//  List<Operation> opList=await dbHelper.getOperationList();
//
//  await dbHelper.deleteAllOperations();
//
//  opList=await dbHelper.getOperationList();
//
//  var abc="";

  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('doesDbHaveDataFromServer', false);

}