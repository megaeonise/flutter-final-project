import 'package:final_project/src/remote/api.dart';
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  //put the friend list call here, we can have a me call
  List<dynamic> _friends = [];
  Future<void> _fetchList() async {
    final friends = await getFriends();
    setState(() {
      _friends = friends;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    if (_friends.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Friend List")),
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
    if (_friends[0] == "empty") {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Friend List")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("No friends found.")],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Friend List")),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
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
                            Text(friend.username),
                            Text("Coin: ${friend.coin.toString()}"),
                            Text("Points: ${friend.points.toString()}"),
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
    );
    // replace the text with bottom and put the friend thing here
    // ListView.builder(itemCount: _friends.length, itemBuilder: (context, index) {
    //   final friend = _friends[index];
    //   return the friend list tile here
    // }));
  }
}
