import 'package:final_project/src/models/user.dart';
import 'package:final_project/src/remote/api.dart';
import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<dynamic> _items = [];
  User? _user;

  Future<void> _fetchList() async {
    final items = await getShop();
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  Future<void> _fetchMe() async {
    final user = await getMe();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> handleBuy(id) async {
    final status = await putBuyItem(id);
    if (status) {
      print("item bought");
      _fetchMe();
    } else {
      print("item buy error");
    }
  }

  Future<void> handleRoll() async {
    final status = await putRollItem(20); //the cost is hardcoded for now
    if (status) {
      print("item rolled");
      _fetchMe();
    } else {
      print("item roll error");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMe();
    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Inventory")),
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
    if (_items[0] == "empty") {
      return Scaffold(
        appBar: AppBar(elevation: 2, title: Text("Inventory")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("No items found.")],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Inventory")),
      body: Column(
        children: [
          if (_user != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Coins: ${_user!.coin}'),
                SizedBox(width: 50),
                Text('Points: ${_user!.points}'),
              ],
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => handleRoll(),
            child: Text("Roll for item"),
          ),
          SizedBox(height: 20),
          Flexible(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 220,
                            height: 100,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(item.description),
                                    Text("Rarity: ${item.rarity}"),
                                    Text(
                                      "Cost: ${item.cost.toString()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => handleBuy(item.id),
                                  child: Text("Buy item"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
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
