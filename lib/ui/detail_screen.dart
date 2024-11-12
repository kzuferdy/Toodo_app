import 'package:flutter/material.dart';
import 'package:toodo_app/models/task.dart';
import 'package:toodo_app/models/subtask.dart';

class DetailScreen extends StatefulWidget {
  final Task task;

  DetailScreen({required this.task});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _subtaskController = TextEditingController();

  void _addSubtask() {
    if (_subtaskController.text.isNotEmpty) {
      setState(() {
        widget.task.addSubtask(Subtask(
          id: DateTime.now().toString(), // Simple unique ID
          title: _subtaskController.text,
        ));
        _subtaskController.clear();
      });
    }
  }

  void _toggleSubtask(Subtask subtask) {
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021526), // Background color
      appBar: AppBar(
        title: Text(widget.task.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF021526), // Same background color for consistency
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              'Title: ${widget.task.title}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Description
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.task.description,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 20),
            // Subtask Header
            Text(
              'Subtasks:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            // Subtask Input Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: InputDecoration(
                      hintText: 'Add a subtask',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addSubtask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9764C7), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Subtask List
            Expanded(
              child: ListView.builder(
                itemCount: widget.task.subtasks.length,
                itemBuilder: (context, index) {
                  Subtask subtask = widget.task.subtasks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white10,
                    child: ListTile(
                      leading: Checkbox(
                        value: subtask.isCompleted,
                        onChanged: (_) => _toggleSubtask(subtask),
                        activeColor: Color(0xFF9764C7),
                      ),
                      title: Text(
                        subtask.title,
                        style: TextStyle(
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }
}
