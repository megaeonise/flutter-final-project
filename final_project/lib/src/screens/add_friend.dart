import 'package:final_project/src/models/user.dart';
import 'package:final_project/src/remote/api.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  final _friendSearchFieldController = TextEditingController();

  Future<void> _fetchList() async {
    final users = await getUsers();
    setState(() {
      _users = users;
      _filteredUsers = users;
    });
  }

  handleSearch(query) {
    List<dynamic> queriedUsers = [];
    if (query == "") {
      setState(() {
        _filteredUsers = _users;
      });
    } else {
      for (User user in _users) {
        if (user.username.contains(query)) {
          queriedUsers.add(user);
        }
        setState(() {
          _filteredUsers = queriedUsers;
        });
      }
    }
  }

  handleAddFriend(id) async {
    final status = await postAddFriend(id);
    if (status) {
      print("friend added");
    } else {
      print("friend add error occured");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    if (_users.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Add Friend")),
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
    if (_users[0] == "empty") {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Add Friend")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("No users found.")],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Add Friend")),
      body: Column(
        children: [
          TextField(
            controller: _friendSearchFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search for your friend",
              suffixIcon: IconButton(
                onPressed: handleSearch(_friendSearchFieldController.text),
                icon: Icon(Icons.search),
              ),
            ),
          ),

          Flexible(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 170,
                            height: 100,
                            child: Column(
                              children: [
                                Text(user.username),
                                Text("Coin: ${user.coin.toString()}"),
                                Text("Points: ${user.points.toString()}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          handleAddFriend(user.id);
                        },
                        child: Text("Add Friend"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    // replace the text with bottom and put the friend thing here
    // ListView.builder(itemCount: _friends.length, itemBuilder: (context, index) {
    //   final friend = _friends[index];
    //   return the friend list tile here
    // }));
  }
}
//SignUpForm