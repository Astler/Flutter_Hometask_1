import 'dart:convert';

import 'package:hw1/ToDoItem.dart';
import 'dart:io';

var appDataFile = '${Directory.current.path}\\data\\app_data.json';

class ToDoList {
  var path = '${Directory.current.path}\\data\\todo_list.json';

  List<dynamic> getAllItems() {
    var file_data = File(path).readAsStringSync();

    if (file_data.isNotEmpty) {
      var notes = jsonDecode(file_data).map((i) => decodeItemsList(i)).toList();

      return notes;
    } else {
      return List.empty(growable: true);
    }
  }

  void addNewItem(ToDoItem item) {
    var items = getAllItems();
    items.add(item);
    writeItemsToFile(items);
  }

  void addFewItems() {}

  void deleteItem(String id) {}

  void currentListSummary() {}

  void writeItemsToFile(List<dynamic> items) {
    File(path).writeAsStringSync(jsonEncode(items));
  }
}

void checkDataFile() {
  if (File(appDataFile).existsSync()) {
    //OK
  }
  else {
    File(appDataFile).writeAsStringSync(
        jsonEncode(ToDoListData(0, 0, 0, 0, 0)));
  }
}

ToDoListData getToDoListData() {
  var file_data = File(appDataFile).readAsStringSync();

  print(file_data);

  return ToDoListData.fromJson(jsonDecode(file_data));
}

void updateToDoListData(ToDoListData data) {
  File(appDataFile).writeAsStringSync(jsonEncode(data));
}

class ToDoListData {
  int nextId;
  int createdPlainToDos;
  int createdRecurringToDos;

  int deletedPlainToDos;
  int deletedRecurringToDos;

  ToDoListData(this.nextId,
      this.createdPlainToDos,
      this.createdRecurringToDos,
      this.deletedPlainToDos,
      this.deletedRecurringToDos);

  factory ToDoListData.fromJson(dynamic json) {
    return ToDoListData(
        json['nextId'] as int,
        json['createdPlainToDos'] as int,
        json['createdRecurringToDos'] as int,
        json['deletedPlainToDos'] as int,
        json['deletedRecurringToDos'] as int);
  }

  Map toJson() =>
      {
        'nextId': nextId,
        'createdPlainToDos': createdPlainToDos,
        'createdRecurringToDos': createdRecurringToDos,
        'deletedPlainToDos': deletedPlainToDos,
        'deletedRecurringToDos': deletedRecurringToDos,
      };
}
