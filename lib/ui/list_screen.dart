import 'package:flutter/material.dart';
import 'package:toodo_app/services/api_task.dart';
import 'package:toodo_app/models/task.dart';
import 'package:toodo_app/ui/detail_screen.dart';

class ListScreen extends StatefulWidget {
  final String token;

  ListScreen({required this.token});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TaskService _taskService = TaskService();
  late Future<List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _taskService.fetchTasks(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021526), 
      appBar: AppBar(
        title: Text('Task List', style: TextStyle(color: Color(0xFF9764C7))),
        backgroundColor: Color(0xFF021526),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFF9764C7)),
            onPressed: () => _showAddTaskDialog(),
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found.'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(
                      task.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(task: task),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showUpdateTaskDialog(task);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(task.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String recordType = 'TO_DO';
    String recurrence = 'NONE';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                value: recordType,
                onChanged: (String? newValue) {
                  setState(() {
                    recordType = newValue!;
                  });
                },
                items: <String>[
                  'TO_DO', 'OBJECTIVE', 'PROJECT', 'MILESTONE', 'AGENDA',
                  'DECISION', 'LEAD', 'DEAL', 'TICKET', 'GOAL', 'STRATEGY',
                  'RESULT', 'MEETING', 'CONTRACT'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: recurrence,
                onChanged: (String? newValue) {
                  setState(() {
                    recurrence = newValue!;
                  });
                },
                items: <String>[
                  'NONE', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY', 'WEEKDAY'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title and description cannot be empty.')),
                  );
                } else {
                  _addTask(title, description, recordType, recurrence);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTask(String title, String description, String recordType, String recurrence) async {
    try {
      await _taskService.addTask(widget.token, title, description, recordType, recurrence);
      setState(() {
        _tasks = _taskService.fetchTasks(widget.token);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $e')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteTask(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(int id) async {
    try {
      await _taskService.deleteTask(widget.token, id);
      setState(() {
        _tasks = _taskService.fetchTasks(widget.token);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  Future<void> _showUpdateTaskDialog(Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    String recordType = task.recordType;
    String recurrence = task.recurrence;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                value: recordType,
                onChanged: (String? newValue) {
                  setState(() {
                    recordType = newValue!;
                  });
                },
                items: <String>[
                  'TO_DO', 'OBJECTIVE', 'PROJECT', 'MILESTONE', 'AGENDA',
                  'DECISION', 'LEAD', 'DEAL', 'TICKET', 'GOAL', 'STRATEGY',
                  'RESULT', 'MEETING', 'CONTRACT'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: recurrence,
                onChanged: (String? newValue) {
                  setState(() {
                    recurrence = newValue!;
                  });
                },
                items: <String>[
                  'NONE', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY', 'WEEKDAY'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title and description cannot be empty.')),
                  );
                } else {
                  _updateTask(task.id, title, description, recordType, recurrence);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTask(int id, String title, String description, String recordType, String recurrence) async {
    try {
      await _taskService.updateTask(widget.token, id, title, description, recordType, recurrence);
      setState(() {
        _tasks = _taskService.fetchTasks(widget.token);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }
}
