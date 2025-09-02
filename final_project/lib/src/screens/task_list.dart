//use flutter timer here and post and get from user task list, you dont need task model, just make a user model
import 'package:final_project/src/models/task.dart';
import 'package:final_project/src/remote/api.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _AddTaskList();
}

class _AddTaskList extends State<TaskList> {
  List<dynamic> _tasks = [];
  List<dynamic> _filteredTasks = [];
  final _taskSearchController = TextEditingController();

  Future<void> _fetchList() async {
    final tasks = await getTasks();
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  handleSearch(query) {
    List<dynamic> queriedTasks = [];
    if (query == "") {
      setState(() {
        _filteredTasks = _tasks;
      });
    } else {
      for (Task task in _tasks) {
        if (task.title.contains(query)) {
          queriedTasks.add(task);
        }
        setState(() {
          _filteredTasks = queriedTasks;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Task List")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Loading")],
          ),
        ),
      );
    }
    if (_tasks[0] == "empty") {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Task List")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _taskSearchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Filter tasks",
                ),
              ),
              Text("No tasks found."),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Task List")),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _taskSearchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Filter tasks",
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = _filteredTasks[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 170,
                            height: 100,
                            child: Column(
                              children: [
                                Text(task.title),
                                Text(task.body),
                                Text(
                                  "Time required: ${task.completionTime.toString()} minutes",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//SignUpForm