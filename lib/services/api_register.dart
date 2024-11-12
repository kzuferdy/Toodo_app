import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRegister {
  final String baseUrl = 'https://motoriz.co/api/v1';

  Future<bool> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sales-marketing/customer/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'full_name': fullName,
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle different status codes and return false
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}