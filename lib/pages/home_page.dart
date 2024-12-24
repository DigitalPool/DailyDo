import 'package:daily_do/utils/dialog_box.dart';
import 'package:flutter/material.dart';

import '../utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//text controller
  final _controller = TextEditingController();

  List toDoList = [
    ["Make tutorial", false],
    ["Make tutorial", false],
  ];

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  //checkbox was tapped
  void checkboxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

//saveNewTask
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        toDoList.add([_controller.text, false]);
        _controller.clear();
      });
    }
    Navigator.of(context).pop(); // Clear the text field after saving
    // Close the dialog box
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
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: toDoList[index][0],
              taskCompleted: toDoList[index][1],
              onChanged: (value) => checkboxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ));
  }
}
