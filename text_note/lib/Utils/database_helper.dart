import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/Models/note.dart';
import 'package:todo_list/Models/operation.dart';
import 'package:todo_list/Utils/rest_helper.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

	String noteTable = 'note_table';
	String operationTable = 'operation_table';
	String colId = 'id';
	String colTitle = 'title';
	String colDescription = 'content';

	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelper;
	}

	Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}

	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'text_note.db';

		// Open/create the database at a given path
		var notesDatabase = await openDatabase(path, version: 10, onCreate: _createDb,onUpgrade: _onUpgrade);
		return notesDatabase;
	}

	void _createDb(Database db, int newVersion) async {

		await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
				'$colDescription TEXT)');
	}

	//change version in openDatabase and it executes this
	void _onUpgrade(Database db, int oldVersion, int newVersion) {
		if (oldVersion < newVersion) {
//			db.execute('CREATE TABLE IF NOT EXISTS temp_table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
//					'$colDescription TEXT)');
//			db.execute("DROP TABLE IF EXISTS $noteTable;");
//			db.execute("ALTER TABLE temp_table RENAME TO $noteTable;");
			db.execute(
					'CREATE TABLE IF NOT EXISTS $operationTable( type TEXT,$colId INTEGER, $colTitle TEXT, '
							'$colDescription TEXT)');
		}
	}

	Future deleteAllOperations() async {
		Database db = await this.database;
		db.execute("DELETE FROM $operationTable;");
	}

	Future deleteAllNotes() async {
		Database db = await this.database;
		db.execute("DELETE FROM $noteTable;");
	}

	// Fetch Operation: Get all note objects from database
	Future<List<Map<String, dynamic>>> getNoteMapList() async {
		Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colTitle ASC');
		var result = await db.query(noteTable, orderBy: '$colTitle ASC');
		return result;
	}

	Future<List<Map<String, dynamic>>> getOperationMapList() async {
		Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colTitle ASC');
		var result = await db.query(operationTable);
		return result;
	}

	Future<int> insertOperation(Operation operation) async {
		Database db = await this.database;
		var result = await db.insert(operationTable, operation.toMap());
		return result;
	}

	// Insert Operation: Insert a note object to database
	Future<int> insertNote(Note note) async {
		Database db = await this.database;
		var result = await db.insert(noteTable, note.toMap());
		return result;
	}

	// Update Operation: Update a note object and save it to database
	Future<int> updateNote(Note note) async {
		var db = await this.database;
		var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
		return result;
	}

	// Delete Operation: Delete a note object from database
	Future<int> deleteNote(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'note List' [ List<Note> ]
	Future<List<Note>> getNoteList() async {

		var noteMapList = await getNoteMapList(); // Get 'Map List' from database

		List<Note> noteList = List<Note>();
		// For loop to create a 'note List' from a 'Map List'
		for (int i = 0; i < noteMapList.length; i++) {
			noteList.add(Note.fromMapObject(noteMapList[i]));
		}

		return noteList;
	}

	Future<List<Operation>> getOperationList() async {

		var operMapList = await getOperationMapList(); // Get 'Map List' from database

		List<Operation> operList = List<Operation>();
		// For loop to create a 'note List' from a 'Map List'
		for (int i = 0; i < operMapList.length; i++) {
			operList.add(Operation.fromMapObject(operMapList[i]));
		}

		return operList;
	}


}







