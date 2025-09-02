import 'package:final_project/src/remote/api.dart';
import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<dynamic> _items = [];
  Future<void> _fetchList() async {
    final items = await getInventory();
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
          Flexible(
            child: ListView.builder(
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
                        width: 170,
                        height: 100,
                        child: Column(
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(item.description),
                            Text("Rarity: ${item.rarity}"),
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
