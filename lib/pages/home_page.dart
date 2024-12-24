import 'package:daily_do/data/database.dart';
import 'package:daily_do/utils/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//reference the box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if first time create data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
		db.loadData();
	}
    super.initState();
  }

//text controller
  final _controller = TextEditingController();

//   List db.toDoList = [
//     ["Make tutorial", false],
//     ["Make tutorial", false],
//   ];

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
	db.updateDataBase();
  }

  //checkbox was tapped
  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
	db.updateDataBase();
  }

//saveNewTask
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.toDoList.add([_controller.text, false]);
        _controller.clear();
      });
    }
    Navigator.of(context).pop(); // Clear the text field after saving
    // Close the dialog box

	//update database
	db.updateDataBase();
  }

// create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller:
              _controller, // Ensure this is a valid TextEditingController
          onSave: saveNewTask, // Function reference with correct signature
          onCancel: () {
            _controller.clear(); // Clear the text field on cancel
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          backgroundColor: Colors.amber[300],
          title:
              (Text("DailyDo", style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: createNewTask, child: Icon(Icons.add)),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkboxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ));
  }
}
