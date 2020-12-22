import 'package:todo_list/Models/note.dart';
import 'package:todo_list/Utils/rest_helper.dart';

Future main() async {
  RestHelper rest=RestHelper();
  List<Note> notes= await rest.getNotes("/notes");

  Note note1=Note("note55", null,"content55");
  note1.id==33;
  await rest.insertNote(note1);

  notes= await rest.getNotes("/notes");

  note1=notes[notes.length-1];
  note1.title+="_updated";
  rest.updateNote(note1);

  notes= await rest.getNotes("/notes");

  await rest.deleteNote(note1.id);

  notes= await rest.getNotes("/notes");

  var abc="";
}