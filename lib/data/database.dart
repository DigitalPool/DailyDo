import 'package:hive/hive.dart';

class ToDoDataBase{

	List toDoList = [];

	//reference the box
	final _myBox = Hive.box('myBox');

	// run this if this is the first time
	void createInitialData(){
	toDoList = [
    	["Make tutorial", false],
    	["Do Exercise", false],
	];
	}

	//anytime after the first time get the stored data
	void loadData(){
		toDoList = _myBox.get("TODOLIST");
	}

	//update data each time as well
	void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
