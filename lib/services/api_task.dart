import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toodo_app/models/task.dart';

class TaskService {
  final String baseUrl = 'https://motoriz.co/api/v1';

  Future<List<Task>> fetchTasks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> tasksJson = data['data'];
      return tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(String token, String title, String description, String recordType, String recurrence, {int? parentId}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'record_type': recordType,
        'recurrence': recurrence,
        'parent_id': parentId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(String token, int id, String title, String description, String recordType, String recurrence) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'record_type': recordType,
        'recurrence': recurrence,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}

