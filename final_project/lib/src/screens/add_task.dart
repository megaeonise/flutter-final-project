import 'package:final_project/src/remote/api.dart';
import 'package:final_project/src/screens/task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleFieldController = TextEditingController();
  final _bodyFieldController = TextEditingController();
  final _completionTimeFieldController = TextEditingController();
  bool _isUrgent = false;
  Color _pickerColor = Color.fromARGB(255, 144, 194, 255);
  Color _currentColor = Color.fromARGB(255, 144, 194, 255);

  handleAddTask(title, body, completionTime) async {
    String hexColor =
        "0x${(_currentColor.a * 255).toInt().toRadixString(16).padLeft(2, '0')}${(_currentColor.r * 255).toInt().toRadixString(16).padLeft(2, '0')}${(_currentColor.g * 255).toInt().toRadixString(16).padLeft(2, '0')}${(_currentColor.b * 255).toInt().toRadixString(16).padLeft(2, '0')}";
    String time = completionTime;
    if (completionTime == "") {
      time = "1";
    }
    final status = await postAddTask(title, body, _isUrgent, hexColor, time);
    if (status) {
      print("task added");
    } else {
      print("task add error occured");
    }
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TaskList()),
      );
    }
  }

  void changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Add Task")),
      body: Column(
        children: [
          TextField(
            controller: _titleFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Set task title",
            ),
          ),
          TextField(
            controller: _bodyFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Set task body",
            ),
          ),
          Text("Set task as urgent"),
          Checkbox(
            semanticLabel: "Set task as urgent",
            value: _isUrgent,
            onChanged: (bool? value) {
              setState(() {
                _isUrgent = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () => _dialogBuilder(context),
            child: Text("Pick task color"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Current color: "),
              SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: _currentColor),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: _completionTimeFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Set task completion time in minutes",
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          ElevatedButton(
            onPressed: () {
              handleAddTask(
                _titleFieldController.text,
                _bodyFieldController.text,
                _completionTimeFieldController.text,
              );
            },
            child: Text("Add Task"),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: changeColor,
            ),
            // Use Material color picker:
            //
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   showLabel: true, // only on portrait mode
            // ),
            //
            // Use Block color picker:
            //
            // child: BlockPicker(
            //   pickerColor: currentColor,
            //   onColorChanged: changeColor,
            // ),
            //
            // child: MultipleChoiceBlockPicker(
            //   pickerColors: currentColors,
            //   onColorsChanged: changeColors,
            // ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Choose color'),
              onPressed: () {
                setState(() => _currentColor = _pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
