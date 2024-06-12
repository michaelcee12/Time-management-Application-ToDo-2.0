import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  //reference the box
  final _myBox = Hive.box('myBox');

  //run this method if this is the first time running the app
  void createInitalData() {
    toDoList = [
      ["Do excercise", false, ""],
      ["Buy Food", false, ""],
    ];
  }

  //load the data from the database with "key" as the key of reference
  void loadDatabase() {
    toDoList = _myBox.get('key');
  }

  //update the data in database
  void updateDatabase() {
    _myBox.put('key', toDoList);
  }

  // Add a new task to the list
  void addTask(String name, String date) {
    toDoList.add([name, false, date]);
    updateDatabase();
  }

  // Sort tasks by date
  void sortByDate() {
    toDoList.sort((a, b) {
      DateTime dateA = a[2].isEmpty ? DateTime(2101) : DateTime.parse(a[2]);
      DateTime dateB = b[2].isEmpty ? DateTime(2101) : DateTime.parse(b[2]);
      return dateB.compareTo(dateA);
    });
  }
}
