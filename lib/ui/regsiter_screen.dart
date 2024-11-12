import 'package:flutter/material.dart';
import 'package:toodo_app/services/api_register.dart';
import 'package:toodo_app/ui/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ApiRegister _apiRegister = ApiRegister();

  void register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _apiRegister.register(
        fullName: _fullNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful')));
        // Navigate back to LoginScreen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021526), // Background color
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF021526),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_fullNameController, 'Full Name', false),
                _buildTextField(_usernameController, 'Username', false),
                _buildTextField(_emailController, 'Email', false, emailValidation: true),
                _buildTextField(_phoneController, 'Phone', false),
                _buildTextField(_passwordController, 'Password', true),
                _buildTextField(_confirmPasswordController, 'Confirm Password', true, confirmPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9764C7), // Button color
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Register', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the text fields with common styling
  Widget _buildTextField(TextEditingController controller, String label, bool obscureText, {bool emailValidation = false, bool confirmPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Please enter $label';
          if (emailValidation && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Please enter a valid email';
          if (confirmPassword && value != _passwordController.text) return 'Passwords do not match';
          return null;
        },
      ),
    );
  }
}
