enum ToDoTypes { plain, recurring }
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

extension DayOfWeekExtension on DayOfWeek {
  String get shortName {
    switch (this) {
      case DayOfWeek.monday: return 'm';
      case DayOfWeek.tuesday: return 'tu';
      case DayOfWeek.wednesday: return 'w';
      case DayOfWeek.thursday: return 'th';
      case DayOfWeek.friday: return 'f';
      case DayOfWeek.saturday: return 'sa';
      case DayOfWeek.sunday: return 'su';
      default:
        return null;
    }
  }
}

DayOfWeek dayOfWeekByString(String day) {
  var day_st = DayOfWeek.monday;

  switch (day) {
    case 'tu':
      day_st = DayOfWeek.tuesday;
      break;
    case 'w':
      day_st = DayOfWeek.wednesday;
      break;
    case 'th':
      day_st = DayOfWeek.thursday;
      break;
    case 'f':
      day_st = DayOfWeek.friday;
      break;
    case 'sa':
      day_st = DayOfWeek.saturday;
      break;
    case 'su':
      day_st = DayOfWeek.sunday;
      break;
  }

  return day_st;
}

DayOfWeek getDayFromString(String day) {
  for (var element in DayOfWeek.values) {
    if (element.toString() == day) {
      return element;
    }
  }
  return null;
}

ToDoTypes getNoteTypeFromString(String day) {
  for (var element in ToDoTypes.values) {
    if (element.toString() == day) {
      return element;
    }
  }
  return null;
}

ToDoItem decodeItemsList(dynamic json) {
  print(json);
  print(json['id']);
  print(json['day_of_week']);
  if (json['day_of_week'] != null) {
    return RecurringToDoItem.fromJson(json);
  } else {
    return PlainToDoItem.fromJson(json);
  }
}

class Task {
  final int id;
  String title;
  String text;
  final ToDoTypes type;

  Task(this.id, this.type);

  String getNoteData() => '';

  Map toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'type': type.toString(),
      };
}

abstract class ToDoItem implements Task {
  @override
  int get id => _id;

  @override
  ToDoTypes get type => _type;

  @override
  String get text => _text;

  @override
  String get title => _title;

  int _id;
  String _title;
  String _text;
  ToDoTypes _type;

  ToDoItem(
    this._id,
    this._title,
    this._text,
    this._type,
  );

  @override
  set text(String _text) {
    text = _text;
  }

  @override
  set title(String _title) {
    title = _title;
  }

  Map toJson() => {
        if (id is int) 'id': id,
        if (title is String) 'title': title,
        if (title is String) 'text': text,
        if (type is ToDoTypes) 'type': type.toString()
      };

  @override
  String getNoteData() => 'id = $id -> $title: $text';
}

class PlainToDoItem extends ToDoItem {
  PlainToDoItem(id, title, text) : super(id, title, text, ToDoTypes.plain);

  factory PlainToDoItem.fromJson(dynamic json) {
    return PlainToDoItem(
        json['id'] as int, json['title'] as String, json['text'] as String);
  }

  @override
  Map toJson() => {
        if (id is int) 'id': id,
        if (title is String) 'title': title,
        if (title is String) 'text': text,
        if (type is ToDoTypes) 'type': type.toString()
      };
}

class RecurringToDoItem extends ToDoItem {
  DayOfWeek dayOfWeek;

  RecurringToDoItem(id, title, text, this.dayOfWeek)
      : super(id, title, text, ToDoTypes.recurring);

  factory RecurringToDoItem.fromJson(dynamic json) {
    return RecurringToDoItem(
        json['id'] as int,
        json['title'] as String,
        json['text'] as String,
        getDayFromString(json['day_of_week'] as String));
  }

  @override
  Map toJson() => {
        if (id is int) 'id': id,
        if (title is String) 'title': title,
        if (title is String) 'text': text,
        if (dayOfWeek is DayOfWeek) 'day_of_week': dayOfWeek.toString(),
        if (type is ToDoTypes) 'type': type.toString()
      };

  @override
  String getNoteData() =>
      'id = $id -> $title: $text \t DAY OF WEEK: $dayOfWeek';
}
