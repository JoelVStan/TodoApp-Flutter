import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/database.dart';
import 'package:to_do/dialog_box.dart';
import 'package:to_do/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');

  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // app first ever open
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    else {
      // user already opened app
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  // List toDoList = [
  //   ["Make video", false]
  // ];

  void checkBoxChanged(bool? value, int index) {
     setState(() {
       db.toDoList[index][1] = !db.toDoList[index][1];
     });
     db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([ _controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void cancelTask() {
    Navigator.of(context).pop();
    _controller.clear();
  }

  void createNewTask() {
    showDialog(context: context, builder: (context) {
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: cancelTask, 
      );
    },);
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('TO DO'),
        centerTitle: true,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        ),

      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            );
        },
      ),
    );
  }
}