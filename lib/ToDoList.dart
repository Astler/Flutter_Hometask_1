import 'dart:convert';

import 'package:hw1/ToDoItem.dart';
import 'dart:io';

var appDataFile = '${Directory.current.path}\\data\\app_data.json';

class ToDoList {
  var path = '${Directory.current.path}\\data\\todo_list.json';

  List<dynamic> getAllTasks() {
    var file_data = File(path).readAsStringSync();

    if (file_data.isNotEmpty) {
      var notes = jsonDecode(file_data).map((i) => decodeItemsList(i)).toList();

      return notes;
    } else {
      return List.empty(growable: true);
    }
  }

  Map<int, dynamic> getAllTasksMap() {
    var file_data = File(path).readAsStringSync();

    var map = <int, dynamic>{};

    if (file_data.isNotEmpty) {
      var notes = jsonDecode(file_data).map((i) => decodeItemsList(i));

      for (var note in notes) {
        map[note.id] = note;
      }

      return map;
    } else {
      return Map.identity();
    }
  }

  void addNewTask(Task item) {
    if (item != null) {
      var items = getAllTasks();
      items.add(item);
      writeItemsToFile(items);
    }
  }

  void addFewTasks(List<dynamic> tasks) {
    var items = getAllTasks();

    var data = getToDoListData();

    for (var item in tasks) {
      if (item is RecurringToDoItem) {
        data.createdRecurringToDos += 1;
      } else {
        data.createdPlainToDos += 1;
      }
    }

    updateToDoListData(data);

    var newItemsList = [...items, ...?tasks];
    writeItemsToFile(newItemsList);
  }

  void deleteItem(int id) {
    var items = getAllTasksMap();

    var item = items[id];
    var data = getToDoListData();

    if (item is RecurringToDoItem) {
      data.deletedRecurringToDos += 1;
    } else {
      data.deletedPlainToDos += 1;
    }

    updateToDoListData(data);

    items.remove(id);
    writeItemsToFile(items.values.toList());
  }

  void currentListSummary() {}

  void writeItemsToFile(List<dynamic> items) {
    File(path).writeAsStringSync(jsonEncode(items));
  }

  void checkDataFile() {
    if (File(appDataFile).existsSync()) {
      //OK
    } else {
      File(appDataFile)
          .writeAsStringSync(jsonEncode(ToDoListData(0, 0, 0, 0, 0)));
    }
  }

  ToDoListData getToDoListData() {
    var file_data = File(appDataFile).readAsStringSync();
    //print(file_data);
    return ToDoListData.fromJson(jsonDecode(file_data));
  }

  void updateToDoListData(ToDoListData data) {
    File(appDataFile).writeAsStringSync(jsonEncode(data));
  }
}

class ToDoListData {
  int nextId;
  int createdPlainToDos;
  int createdRecurringToDos;

  int deletedPlainToDos;
  int deletedRecurringToDos;

  ToDoListData(this.nextId, this.createdPlainToDos, this.createdRecurringToDos,
      this.deletedPlainToDos, this.deletedRecurringToDos);

  factory ToDoListData.fromJson(dynamic json) {
    return ToDoListData(
        json['nextId'] as int,
        json['createdPlainToDos'] as int,
        json['createdRecurringToDos'] as int,
        json['deletedPlainToDos'] as int,
        json['deletedRecurringToDos'] as int);
  }

  Map toJson() => {
        'nextId': nextId,
        'createdPlainToDos': createdPlainToDos,
        'createdRecurringToDos': createdRecurringToDos,
        'deletedPlainToDos': deletedPlainToDos,
        'deletedRecurringToDos': deletedRecurringToDos,
      };
}
