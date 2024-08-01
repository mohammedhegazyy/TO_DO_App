import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  final _controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void editTask(int index) {
    _controller.text = db.toDoList[index][0];
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: () {
              setState(() {
                db.toDoList[index][0] = _controller.text;
                _controller.clear();
              });
              Navigator.of(context).pop();
              db.updateDataBase();
            },
            onCancel: () {
              _controller.clear();
              Navigator.of(context).pop();
            });
      },
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = db.toDoList.removeAt(oldIndex);
      db.toDoList.insert(newIndex, item);
      db.updateDataBase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
        leading: const Icon(Icons.task_rounded),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow[200],
        child: const Icon(Icons.add),
      ),
      body: ReorderableListView(
        onReorder: onReorder,
        children: List.generate(db.toDoList.length, (index) {
          return ToDoTile(
            key: ValueKey(db.toDoList[index][0]),
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: () => editTask(index),
          );
        }),
      ),
    );
  }
}
