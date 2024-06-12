import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/components/dialog_box.dart';
import 'package:to_do_app/components/todo_tile.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the box
  final _myBox = Hive.box('myBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    //if this is first time running application, create default data
    if (_myBox.get("key") == null) {
      db.createInitalData();
    } else {
      // there's existing data
      db.loadDatabase();
    }
    db.sortByDate();

    super.initState();
  }

  //text controller
  final _controller = TextEditingController();
  final dateController = TextEditingController();

  //checkbox was tapped

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  //Save new Task
  // void saveNewTask() {
  //   setState(() {
  //     db.toDoList.add([_controller.text, false, dateController.text]);
  //     _controller.clear();
  //   });
  //   Navigator.of(context).pop();
  //   db.updateDatabase();
  // }

  // edit Task
  void editTask(int index) {
    final taskController = TextEditingController(text: db.toDoList[index][0]);
    final dateController = TextEditingController(text: db.toDoList[index][2]);
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: taskController,
          dateController: dateController,
          onSave: () {
            setState(() {
              db.toDoList[index][0] = taskController.text;
              db.toDoList[index][2] = dateController.text;
              db.sortByDate();
            });
            db.updateDatabase();
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  //create New Task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            setState(() {
              db.toDoList.add([_controller.text, false, dateController.text]);
              _controller.clear();
              db.sortByDate();
            });
            Navigator.of(context).pop();
            db.updateDatabase();
          },
          onCancel: () => Navigator.of(context).pop(),
          dateController: dateController,
        );
      },
    );
  }

  //Delete Task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  // signout
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text(
          'STUDENT TIME\nMANAGEMENT',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              onPressed: signUserOut,
              icon: const Icon(
                Icons.logout_rounded,
                size: 28,
              ),
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white24,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            name: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) => editTask(index),
            date: db.toDoList[index][2],
          );
        },
      ),
    );
  }
}
