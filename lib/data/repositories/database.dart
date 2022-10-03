import 'package:firebase_database/firebase_database.dart';
import 'package:mintic_un_todo_core/data/entities/to_do.dart';
import 'package:mintic_un_todo_core/domain/models/to_do.dart';

class RealTimeDatabase {
  DatabaseReference get database => FirebaseDatabase.instance.ref("todo_list");

  Stream<List<ToDo>> get toDoStream {
    return database.onValue.map((event) {
      if (event.snapshot.value == null) {
        return [];
      } else {
        final data = (event.snapshot.value as Map).cast<String, Map>();
        return data.values
            .map((record) =>
                ToDoEntity.fromRecord(record.cast<String, dynamic>()))
            .toList();
      }
    });
  }

  Future<void> delete({required String uuid}) async {
    await database.child(uuid).remove();
  }

  Future<void> save({required ToDo data}) async {
    await database.child(data.uuid).set(data.record);
  }

  Future<ToDo> read({required String uuid}) async {
    final snapshot = await database.child(uuid).get();
    return ToDoEntity.fromRecord(snapshot.value as Map<String, dynamic>);
  }

  Future<List<ToDo>> readAll() async {
    final snapshot = await database.get();
    if (snapshot.value == null) {
      return [];
    } else {
      final data = (snapshot.value as Map).cast<String, Map>();
      return data.values
          .map(
              (record) => ToDoEntity.fromRecord(record.cast<String, dynamic>()))
          .toList();
    }
  }

  Future<void> clear() async {
    await database.remove();
  }

  Future<void> update({required ToDo data}) async {
    await database.child(data.uuid).set(data.record);
  }
}
