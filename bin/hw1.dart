import 'dart:io';

import 'package:hw1/ToDoList.dart' as todo_list;
import 'package:hw1/ToDoItem.dart';
import 'package:hw1/ToDoList.dart';

void main(List<String> arguments) {
  stdout.writeln('TODO Flutter | Hometask #1\n');

  todo_list.checkDataFile();

  var toDoList = todo_list.ToDoList();

  var task = 0;

  while (task != -1) {
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
      stdout.writeln('You choose: $user_input');
      stdout.writeln();
      var task_id = int.parse(user_input);

      switch (task_id) {
        case 1:
          var allItems = toDoList.getAllTasks();

          if (allItems.isNotEmpty) {
            for (var item in allItems) {
              stdout.writeln(item.getNoteData());
            }
            stdout.writeln('\n');
          } else {
            stdout.writeln('For now your ToDo list is empty!\n');
          }
          break;
        case 2:
          stdout.writeln('New ToDo!');

          var todo_type = '';

          do {
            stdout.writeln('Is this ToDo plain (0) or recurring (1)?');
            todo_type = stdin.readLineSync();
          } while (todo_type != '0' && todo_type != '1');

          var task_id = int.parse(todo_type);

          stdout.writeln('Enter Title:');
          var new_item_name = stdin.readLineSync();

          stdout.writeln('Enter Text:');
          var new_item_text = stdin.readLineSync();

          var data = getToDoListData();

          var new_item_id = data.nextId;

          data.nextId += 1;

          if (task_id == 1) {
            var days = ['m', 'tu', 'w', 'th', 'f', 'sa', 'su'];
            var day = '';
            do {
              stdout.writeln('Select a day for this task: $days');
              day = stdin.readLineSync();
            } while (!days.contains(day.toLowerCase()));

            var new_item_day = DayOfWeek.monday;

            switch (day) {
              case 'tu':
                new_item_day = DayOfWeek.tuesday;
                break;
              case 'w':
                new_item_day = DayOfWeek.wednesday;
                break;
              case 'th':
                new_item_day = DayOfWeek.thursday;
                break;
              case 'f':
                new_item_day = DayOfWeek.friday;
                break;
              case 'sa':
                new_item_day = DayOfWeek.saturday;
                break;
              case 'su':
                new_item_day = DayOfWeek.sunday;
                break;
            }

            print(new_item_day.toString());
            toDoList.addNewTask(RecurringToDoItem(
                new_item_id, new_item_name, new_item_text, new_item_day));
            data.createdRecurringToDos += 1;
          } else {
            toDoList.addNewTask(
                PlainToDoItem(new_item_id, new_item_name, new_item_text));
            data.createdPlainToDos += 1;
          }

          todo_list.updateToDoListData(data);

          break;
        case 3:
          var to_menu = false;
          stdout.writeln('Add few notes!');
          var fewTodosList = List.empty(growable: true);

          while (!to_menu) {
            if (fewTodosList.isNotEmpty) {
              stdout.writeln(
                  'You already created ${fewTodosList.length} new notes!');
            }

            var todo_type = '';

            do {
              if (fewTodosList.isNotEmpty) {
                stdout.writeln(
                    'Is this ToDo plain (0) or recurring (1)? Press ENTER to save the notes you\'ve created.');
              } else {
                stdout.writeln(
                    'Is this ToDo plain (0) or recurring (1)? Press ENTER to exit to MM.');
              }
              todo_type = stdin.readLineSync();
            } while (
                todo_type != '0' && todo_type != '1' && todo_type.isNotEmpty);

            if (todo_type.isNotEmpty) {
              var task_id = int.parse(todo_type);

              stdout.writeln('Enter Title:');
              var new_item_name = stdin.readLineSync();

              stdout.writeln('Enter Text:');
              var new_item_text = stdin.readLineSync();

              var data = getToDoListData();

              var new_item_id = data.nextId;

              data.nextId += 1;

              if (task_id == 1) {
                var days = ['m', 'tu', 'w', 'th', 'f', 'sa', 'su'];
                var day = '';
                do {
                  stdout.writeln('Select a day for this task: $days');
                  day = stdin.readLineSync();
                } while (!days.contains(day.toLowerCase()));

                var new_item_day = DayOfWeek.monday;

                switch (day) {
                  case 'tu':
                    new_item_day = DayOfWeek.tuesday;
                    break;
                  case 'w':
                    new_item_day = DayOfWeek.wednesday;
                    break;
                  case 'th':
                    new_item_day = DayOfWeek.thursday;
                    break;
                  case 'f':
                    new_item_day = DayOfWeek.friday;
                    break;
                  case 'sa':
                    new_item_day = DayOfWeek.saturday;
                    break;
                  case 'su':
                    new_item_day = DayOfWeek.sunday;
                    break;
                }

                fewTodosList.add(RecurringToDoItem(
                    new_item_id, new_item_name, new_item_text, new_item_day));
              } else {
                fewTodosList.add(
                    PlainToDoItem(new_item_id, new_item_name, new_item_text));
              }

              todo_list.updateToDoListData(data);
            } else {
              to_menu = true;
              var data = getToDoListData();

              for (var item in fewTodosList) {
                if (item is RecurringToDoItem) {
                  data.createdRecurringToDos += 1;
                } else {
                  data.createdPlainToDos += 1;
                }
              }

              toDoList.addFewTasks(fewTodosList);
              todo_list.updateToDoListData(data);
            }
          }
          break;
        case 4:
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

          break;
        case 5:
          var data = getToDoListData();
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

          stdout.writeln(
              'Total Notes Now: ${existsPlainTodos + existsRecurringTodos}');
          stdout.writeln(
              'Total Recurring ToDos Now: $existsRecurringTodos');
          stdout.writeln(
              'Total Plain ToDos Now: $existsPlainTodos');
          stdout.writeln();
          stdout.writeln(
              'Total Notes Created: ${data.createdRecurringToDos + data.createdPlainToDos}');
          stdout.writeln(
              'Total Recurring ToDos Created: ${data.createdRecurringToDos}');
          stdout.writeln(
              'Total Plain ToDos Created: ${data.createdPlainToDos}');
          stdout.writeln(
              'Total Notes Deleted: ${data.deletedPlainToDos + data.deletedRecurringToDos}');
          stdout.writeln(
              'Total Recurring ToDos Deleted: ${data.deletedRecurringToDos}');
          stdout.writeln(
              'Total Plain ToDos Deleted: ${data.deletedPlainToDos}');
          stdout.writeln();
          stdout.writeln(
              'Press Enter to return to MM.');

          stdin.readLineSync();
          break;

        default:
          stdout.writeln('\n\n\nIncorrect input!\n\n\n');
      }
    }
  }
}
