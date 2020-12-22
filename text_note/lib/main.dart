import 'package:flutter/material.dart';
import 'package:todo_list/Screens/note_list.dart';
import 'package:todo_list/Screens/note_detail.dart';

import 'Screens/custom_drawer.dart';

void main() {
	runApp(TodoApp());
}

class TodoApp extends StatelessWidget {

	@override
  Widget build(BuildContext context) {

    return MaterialApp(
			title: 'TodoList',
			debugShowCheckedModeBanner: false,
			theme: ThemeData.dark(),
			home:NoteList(),
		);
  }
}