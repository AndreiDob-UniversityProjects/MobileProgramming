
import 'note.dart';

class Operation {

  String type;
  Note note;

  Operation(this.type, this.note);

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (note.id != null) {
      map['id'] = note.id;
    }
    map['type'] =type;
    map['title'] = note.title;
    map['content'] = note.description;

    return map;
  }

  // Extract a Note object from a Map object
  Operation.fromMapObject(Map<String, dynamic> map) {
    this.type=map['type'];
    this.note=Note.withId(map['id'], map['title'], map['content']);
  }
}









