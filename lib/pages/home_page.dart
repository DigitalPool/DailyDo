import 'package:daily_do/data/database.dart';
import 'package:daily_do/main.dart';
import 'package:daily_do/utils/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

import '../utils/todo_tile.dart';

Future<void> showPersistentNotification(
    int id, String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'task_channel_id', // Channel ID
    'Task Notifications', // Channel name
    channelDescription: 'Notifications for individual tasks',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true, // Makes the notification persistent
    autoCancel: false, // Prevents accidental dismissal
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    id, // Use a unique ID for each notification
    title,
    body,
    platformChannelSpecifics,
  );
}


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
      String taskName = db.toDoList[index][0];
      db.toDoList.removeAt(index);

      // Cancel the notification for the deleted task
      flutterLocalNotificationsPlugin.cancel(index);

      // Optionally, show a notification for task deletion
      showPersistentNotification(
        index, // Use the task index or a unique ID
        'Task Deleted',
        'Task "$taskName" has been removed.',
      );
    });
    db.updateDataBase();
  }


  //checkbox was tapped
void checkboxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];

      if (db.toDoList[index][1]) {
        // Task marked as completed
        showPersistentNotification(
          index, // Use the task index as the ID
          'Task "${db.toDoList[index][0]}"',
          '"${db.toDoList[index][0]}" is now completed.',
        );
      } else {
        // Task marked as incomplete
        showPersistentNotification(
          index,
          'Task Updated',
          '"${db.toDoList[index][0]}" is incomplete.',
        );
      }
    });
    db.updateDataBase();
  }


//saveNewTask

void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.toDoList.add([_controller.text, false]);
        // Call the notification function with a unique ID
        showPersistentNotification(
          db.toDoList.length, // Use the index or a unique ID
          'New Task Added',
          'Task "${_controller.text}" is incomplete.',
        );
        _controller.clear();
      });
      Navigator.of(context).pop(); // Close the dialog // Clear the text field after saving
      db.updateDataBase();
    }
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
        title: const Text(
          "DailyDo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: createNewTask,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Ensure it stays circular
        ),
        elevation: 8,
      ),
      body: Column(
        children: [
          // Add a header with instructions
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Swipe left to delete a task',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
          ),
          // Add the list of tasks
          Expanded(
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkboxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
