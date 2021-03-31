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

class Note {
  String getNoteData() => '';
}

abstract class ToDoItem implements Note {
  final int _id;
  String _title;
  String _text;
  final ToDoTypes _type;

  ToDoItem(
    this._id,
    this._title,
    this._text,
    this._type,
  );

  Map toJson() =>
      {
        'id': _id,
        'title': _title,
        'text': _text,
        'type': _type.toString(),
      };

  String getText() => _text;
}

class PlainToDoItem extends ToDoItem {
  PlainToDoItem(id, title, text) : super(id, title, text, ToDoTypes.plain);

  @override
  String getNoteData() => '$_title: $_text';

  factory PlainToDoItem.fromJson(dynamic json) {
    return PlainToDoItem(
        json['id'] as int,
        json['title'] as String,
        json['text'] as String);
  }

  @override
  Map toJson() =>
      {
        'id': _id,
        'title': _title,
        'text': _text,
        'type': _type,
        'type': _type.toString(),
      };

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
  if (json['day_of_week'] != null) {
    return RecurringToDoItem.fromJson(json);
  }
  else {
    return PlainToDoItem.fromJson(json);
  }
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
  Map toJson() =>
      {
        'id': _id,
        'title': _title,
        'text': _text,
        'day_of_week': dayOfWeek.toString(),
        'type': _type.toString(),
      };

  @override
  String getNoteData() => '$_title: $_text $dayOfWeek';
}
