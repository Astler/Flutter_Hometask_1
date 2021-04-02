import 'dart:io';

import 'package:hw1/ToDoList.dart' as todo_list;
import 'package:hw1/ToDoItem.dart';

Task createNewTask(todo_list.ToDoList toDoList) {
  var todo_type = '';

  do {
    stdout.writeln('Is this ToDo plain (0) or recurring (1)?');
    todo_type = stdin.readLineSync();
  } while (todo_type != '0' && todo_type != '1' && todo_type.isNotEmpty);

  if (todo_type.isNotEmpty) {
    var task_type = int.parse(todo_type);

    stdout.writeln('Enter Title:');
    var new_item_name = stdin.readLineSync();

    stdout.writeln('Enter Text:');
    var new_item_text = stdin.readLineSync();

    var data = toDoList.getToDoListData();

    var new_item_id = data.nextId;

    data.nextId += 1;

    if (task_type == 1) {
      var dayShorts = [for (var dayEnum in DayOfWeek.values) dayEnum.shortName];

      var day = '';
      do {
        stdout.writeln('Select a day for this task: $dayShorts');
        day = stdin.readLineSync();
      } while (!dayShorts.contains(day.toLowerCase()));

      var new_item_day = dayOfWeekByString(day);

      data.createdRecurringToDos += 1;
      toDoList.updateToDoListData(data);
      return RecurringToDoItem(
          new_item_id, new_item_name, new_item_text, new_item_day);
    } else {
      data.createdPlainToDos += 1;
      toDoList.updateToDoListData(data);
      return PlainToDoItem(new_item_id, new_item_name, new_item_text);
    }
  }
  else {
    stdout.writeln('Note creation canceled');
    return null;
  }
}

void printSummary(todo_list.ToDoList toDoList) {
  var data = toDoList.getToDoListData();
  var items = toDoList.getAllTasks();

  var existsPlainTodos = 0;
  var existsRecurringTodos = 0;

  for (var item in items) {
    if (item is RecurringToDoItem) {
      existsRecurringTodos += 1;
    } else {
      existsPlainTodos += 1;
    }
  }

  stdout
      .writeln('Total Notes Now: ${existsPlainTodos + existsRecurringTodos}');
  stdout.writeln('Total Recurring ToDos Now: $existsRecurringTodos');
  stdout.writeln('Total Plain ToDos Now: $existsPlainTodos');
  stdout.writeln();
  stdout.writeln(
      'Total Notes Created: ${data.createdRecurringToDos + data.createdPlainToDos}');
  stdout.writeln(
      'Total Recurring ToDos Created: ${data.createdRecurringToDos}');
  stdout.writeln('Total Plain ToDos Created: ${data.createdPlainToDos}');
  stdout.writeln(
      'Total Notes Deleted: ${data.deletedPlainToDos + data.deletedRecurringToDos}');
  stdout.writeln(
      'Total Recurring ToDos Deleted: ${data.deletedRecurringToDos}');
  stdout.writeln('Total Plain ToDos Deleted: ${data.deletedPlainToDos}');
  stdout.writeln();
  stdout.writeln('Press Enter to return to MM.');

  stdin.readLineSync();
}

void printExistingItems(todo_list.ToDoList toDoList) {
  stdout.writeln('Existing ToDo!');
  var allItems = toDoList.getAllTasks();

  if (allItems.isNotEmpty) {
    for (var item in allItems) {
      stdout.writeln(item.getNoteData());
    }
    stdout.writeln();
  } else {
    stdout.writeln('For now your ToDo list is empty!\n');
  }
}

void deleteItem(todo_list.ToDoList toDoList) {
  var to_menu = false;

  while (!to_menu) {
    var allItems = toDoList.getAllTasks();

    if (allItems.isNotEmpty) {
      stdout.writeln('\n');
      for (var item in allItems) {
        stdout.writeln(item.getNoteData());
      }
      stdout.writeln('\n');
    } else {
      stdout.writeln('\nFor now your ToDo list is empty!\n\n');
    }

    stdout.write(
        'Enter task id to delete it or just press Enter to return to MM: ');

    var delete_task_id = stdin.readLineSync();

    if (delete_task_id.isNotEmpty) {
      toDoList.deleteItem(int.parse(delete_task_id));
    } else {
      to_menu = true;
    }
  }
}

void main(List<String> arguments) {
  stdout.writeln('TODO Flutter | Hometask #1\n');

  var toDoList = todo_list.ToDoList();
  toDoList.checkDataFile();

  var task = 0;

  while (task != -1) {
    var correctItems = ['1', '2', '3', '4', '5'];

    stdout.writeln('Choose what to do?');
    stdout.writeln('1) View All ToDo items');
    stdout.writeln('2) Add one new ToDo item');
    stdout.writeln('3) Add one few ToDo items');
    stdout.writeln('4) Delete ToDo by Id');
    stdout.writeln('5) List Summary');
    stdout.writeln('Just press ENTER to Exit');
    stdout.writeln();
    stdout.write('Input: ');

    var user_input = stdin.readLineSync();

    if (user_input.isEmpty) {
      stdout.writeln('See you next time!');
      task = -1;
    } else {
      var task_id = -1;

      if (correctItems.contains(user_input.toString())) {
        task_id = int.parse(user_input);
      }

      switch (task_id) {
        case 1: printExistingItems(toDoList); break;
        case 2:
          stdout.writeln('New ToDo!');
          toDoList.addNewTask(createNewTask(toDoList));
          break;
        case 3:
          var to_menu = false;
          stdout.writeln('Add few notes!');
          var fewTodosList = List.empty(growable: true);

          while (!to_menu) {
            if (fewTodosList.isNotEmpty) {
              stdout.writeln(
                  'You already created ${fewTodosList.length} new notes! Press ENTER to save the notes you\'ve created.');
            }
            else {
              stdout.writeln('Press ENTER to exit to MM.');
            }

            var noteItem = createNewTask(toDoList);

            if (noteItem != null) {
              fewTodosList.add(noteItem);
            } else {
              to_menu = true;
              toDoList.addFewTasks(fewTodosList);
            }
          }
          break;
        case 4: deleteItem(toDoList); break;
        case 5: printSummary(toDoList); break;

        default:
          stdout.writeln('\n\n\nIncorrect input!\n\n\n');
      }
    }
  }
}