//use flutter timer here and post and get from user task list, you dont need task model, just make a user model
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _AddTaskList();
}

class _AddTaskList extends State<TaskList> {
  final _friendSearchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _friendSearchFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Placeholder",
                ),
              ),
              // ListView.builder(itemCount: _users.length, itemBuilder: (context, index) {
              //   final user = _users[index];
              //   return the users list tile here, use the textfield controller to query with searching
              // }));
            ],
          ),
        ),
      ),
    );
  }
}
//SignUpForm