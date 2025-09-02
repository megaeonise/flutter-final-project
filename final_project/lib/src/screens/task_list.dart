//use flutter timer here and post and get from user task list, you dont need task model, just make a user model
import 'package:final_project/src/models/task.dart';
import 'package:final_project/src/remote/api.dart';
import 'package:final_project/src/screens/add_task.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskList();
}

class _TaskList extends State<TaskList> {
  List<dynamic> _tasks = [];
  List<dynamic> _filteredTasks = [];
  final _taskSearchController = TextEditingController();
  late DateTime startTime;
  String currentTask = "";

  Future<void> _fetchList() async {
    final tasks = await getTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _filteredTasks = tasks;
      });
    }
  }

  Future<void> _sendPoints(points, id) async {
    final status = await putPoints(points, id);
    if (mounted) {
      if (status) {
        print("points sent");
        _fetchList();
      } else {
        print("point send error occured");
      }
    }
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

  handleStartTask(id) {
    setState(() {
      startTime = DateTime.now();
      currentTask = id;
    });
  }

  handleEndTask(completionTime, id) {
    DateTime endTime = DateTime.now();
    final timeSpent = endTime.difference(startTime).inMinutes.round();
    num score = ((completionTime - timeSpent) + completionTime) * 100;
    _sendPoints(score, id);
    setState(() {
      currentTask = "";
    });
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
    if (_tasks[0] == "empty" || _filteredTasks.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Task List")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTask()),
                ),
                child: Text("Add task"),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _taskSearchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Filter tasks",
                  suffixIcon: IconButton(
                    onPressed: () => handleSearch(_taskSearchController.text),
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text("No tasks found."),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Task List"),
        actions: [
          IconButton(onPressed: () => _fetchList(), icon: Icon(Icons.refresh)),
        ],
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTask()),
                  );
                },
                child: Text("Add task"),
              ),
              SizedBox(height: 40),

              TextField(
                controller: _taskSearchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Filter tasks",
                  suffixIcon: IconButton(
                    onPressed: () => handleSearch(_taskSearchController.text),
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
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
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(
                                    int.parse(
                                      task.color.substring(2),
                                      radix: 16,
                                    ),
                                  ),
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                if (task.urgent)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Text(
                                      "URGENT TASK",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                Text(task.title),
                                Text(task.body),
                                Text(
                                  "Time required: ${task.completionTime.toString()} minutes",
                                ),
                                SizedBox(height: 20),
                                if (currentTask == task.id && task.urgent)
                                  ElevatedButton(
                                    onPressed: () => handleEndTask(
                                      task.completionTime,
                                      task.id,
                                    ),
                                    child: Text(
                                      "End Task",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (currentTask == task.id && !task.urgent)
                                  ElevatedButton(
                                    onPressed: () => handleEndTask(
                                      task.completionTime,
                                      task.id,
                                    ),
                                    child: Text("End Task"),
                                  ),
                                if (currentTask == "" && !task.urgent)
                                  ElevatedButton(
                                    onPressed: () => handleStartTask(task.id),
                                    child: Text("Start Task"),
                                  ),
                                if (currentTask == "" && task.urgent)
                                  ElevatedButton(
                                    onPressed: () => handleStartTask(task.id),
                                    child: Text(
                                      "Start Task",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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