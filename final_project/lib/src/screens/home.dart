import 'package:final_project/main.dart';
import 'package:final_project/src/screens/add_friend.dart';
import 'package:final_project/src/screens/friend_list.dart';
import 'package:final_project/src/screens/task_list.dart';
import 'package:final_project/src/remote/api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> handleLogout() async {
    final status = await postLogout();
    if (status && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TempButtons()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFriend()),
                );
              },
              child: Text("Add Friend"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendList()),
                );
              },
              child: Text("Friend List"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskList()),
                );
              },
              child: Text("Task List"),
            ),
            ElevatedButton(
              onPressed: () => handleLogout(),
              child: Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
