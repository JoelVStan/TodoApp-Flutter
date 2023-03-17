import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
  final _myBox = Hive.box('mybox');

  // run this method if first time app opening
  void createInitialData() {
    toDoList = [
      ["Water the plants", false],
      ["Go to gym", false],
    ];
  }

  //load data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  //update DB
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }


}