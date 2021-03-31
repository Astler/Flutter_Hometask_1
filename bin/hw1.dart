import 'dart:io';

import 'package:hw1/ToDoList.dart' as todo_list;
import 'package:hw1/ToDoItem.dart';
import 'package:hw1/ToDoList.dart';

void main(List<String> arguments) {
  stdout.writeln('TODO Flutter | Hometask #1\n');

  todo_list.checkDataFile();

  todo_list.ToDoList toDoList = todo_list.ToDoList();
  //
  // List<ToDoItem> itemsList = toDoList.getAllItems();
  //
  // String objText = '{"id": 300, "title": "Astler is God!", "text": "Astler is God! YEEEEEEES!"}';
  //
  // var item = RecurringToDoItem.fromJson(jsonDecode(objText));
  // var item2 = RecurringToDoItem(300, 'God', 'Astler is God', DayOfWeek.monday);
  //
  // print('Hello world: ${itemsList.length}!');
  // print('Hello world: ${item.getNoteData()}!');
  // print('Hello world: ${item2.getNoteData()}!');
  // print('Hello world: ${item2.getNoteData()}!');
  // print('Hello world: ${item2.toJson()}!');
  // print('Hello world: ${jsonEncode(item2.toJson())}!');
  //
  // var item3 = RecurringToDoItem.fromJson(jsonDecode(jsonEncode(item2.toJson())));
  // print('Hello world: ${item3.getNoteData()}!');
  // print('Hello world: ${hw1.calculate()}!');
  //
  // String objArray = '['
  //     '{"id": 300, "title": "Astler is God!", "text": "Astler is God! YEEEEEEES!"},'
  //     '{"id": 301, "title": "Astler is God!", "text": "Astler is God! YEEEEEEES!", "day_of_week": "DayOfWeek.monday"},'
  //     '{"id": 302, "title": "Astler is God!", "text": "Astler is God! YEEEEEEES!"},'
  //     '{"id": 303, "title": "Astler is God!", "text": "Astler is God! YEEEEEEES!"} ]';
  //
  // var notes = jsonDecode(objArray).map((i) => decodeItemsList(i)).toList();
  //
  //  print(jsonDecode(objArray));
  //  print(notes);
  //
  //  print(jsonEncode(notes));
  //
  // stdout.writeln('Type something');
  // String input = stdin.readLineSync();
  // stdout.writeln('You typed: $input');
  //
  var task = 0;

  while (task != -1) {
    stdout.writeln('Choose what to do?');
    stdout.writeln('1) View All ToDo items');
    stdout.writeln('2) Add one new ToDo item');
    stdout.writeln('3) Add one few ToDo items');
    stdout.writeln('4) Delete ToDo by Id');
    stdout.writeln('Just press ENTER to Exit');

    var user_input = stdin.readLineSync();

    if (user_input.isEmpty) {
      stdout.writeln('See you next time!');
      task = -1;
    } else {
      stdout.writeln('You choose: $user_input');

      var task_id = int.parse(user_input);

      switch (task_id) {
        case 1:
          var allItems = toDoList.getAllItems();

          if (allItems.isNotEmpty) {
            for (var item in allItems) {
              stdout.writeln(item.getNoteData());
            }
          }
          else {
            stdout.writeln('\n\n\nFor now your ToDo list is empty!\n\n\n');
          }
          break;
        case 2:
          stdout.writeln('New ToDo!');

          var todo_type = '';

          do {
            stdout.writeln('Is this ToDo plain (0) or regular (1)?');
            todo_type = stdin.readLineSync();
          } while(todo_type != '0' && todo_type != '1');

          var task_id = int.parse(todo_type);

          stdout.writeln('Enter Title:');
          var new_item_name = stdin.readLineSync();

          stdout.writeln('Enter Text:');
          var new_item_text = stdin.readLineSync();

          var data = getToDoListData();

          var new_item_id = data.nextId;

          data.nextId += 1;

          toDoList.addNewItem(PlainToDoItem(new_item_id, new_item_name, new_item_text));
          data.createdPlainToDos += 1;

          todo_list.updateToDoListData(data);

          break;
        case 3:
          break;

        default:
          stdout.writeln('\n\n\nIncorrect input!\n\n\n');
      }
    }
  }
}
