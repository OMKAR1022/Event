import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/student_auth_provider.dart';

import '../../widgets/wave_clipper.dart';

class StudentCreateAccountScreen extends StatefulWidget {
  @override
  _StudentCreateAccountScreenState createState() => _StudentCreateAccountScreenState();
}

class _StudentCreateAccountScreenState extends State<StudentCreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _enrollNoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _classController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _enrollNoController.dispose();
    _departmentController.dispose();
    _classController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Provider.of<StudentAuthProvider>(context, listen: false).createAccount(
          name: _nameController.text,
          phoneNo: _phoneController.text,
          email: _emailController.text,
          enrollNo: _enrollNoController.text,
          department: _departmentController.text,
          className: _classController.text,
          password: _passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.of(context).pop(); // Return to login page
      } catch (e) {
        String errorMessage = 'Error creating account';
        if (e is Exception) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 200,
                color: Colors.blue[700],
                child: Center(
                  child: Text(
                    'Create Student Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty || !value.contains('@') ? 'Please enter a valid email' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _enrollNoController,
                      label: 'Enrollment Number',
                      icon: Icons.numbers,
                      validator: (value) => value!.isEmpty ? 'Please enter your enrollment number' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _departmentController,
                      label: 'Department',
                      icon: Icons.school,
                      validator: (value) => value!.isEmpty ? 'Please enter your department' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _classController,
                      label: 'Class',
                      icon: Icons.class_,
                      validator: (value) => value!.isEmpty ? 'Please enter your class' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters long' : null,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_clock,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Create Account'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Already have an account? Login'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}

