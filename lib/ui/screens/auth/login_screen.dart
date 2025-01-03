import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // Screen size reference
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Fetch the selected user type from the provider
    final loginProvider = Provider.of<LoginProvider>(context);
    final selectedUserType = loginProvider.userType;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Avatar and Titles
            SizedBox(
              height: screenHeight * 0.45, // Adjust based on screen height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: CircleAvatar(
                      radius: screenWidth * 0.15, // Responsive size
                      backgroundImage: const NetworkImage(
                        'https://static.toiimg.com/thumb/msid-70529568,width-400,resizemode-4/70529568.jpg',
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    "MIT ADT",
                    style: TextStyle(
                      fontSize: 24, // Responsive font size
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Event Management System",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section with Login Form
            Container(

              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.05,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Toggle Buttons for User Type Selection
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    isSelected: [
                      selectedUserType == 'Student',
                      selectedUserType == 'Club Member',
                    ],
                    onPressed: (index) {
                      loginProvider.setUserType(
                          index == 0 ? 'Student' : 'Club Member');
                    },
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    color: Colors.black,
                    constraints: BoxConstraints(
                      minHeight: screenHeight * 0.04,
                      minWidth: screenWidth * 0.4,
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Student'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Club Member'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Username Input
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: selectedUserType == 'Student'
                          ? 'Enroll No'
                          : 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Password Input
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: selectedUserType == 'Student'
                          ? 'Mobile No'
                          : 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(selectedUserType == 'Club Member'
                      ? 'Forget Password'
                      : '',style: TextStyle(color: Colors.blueAccent),),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.012,
                        horizontal: screenWidth * 0.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();
                      // Call the login method and handle the result
                      final result = await loginProvider.login(username, password,context);

                      // Show a message based on the result

                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.03 ),
                  const Divider(),
                  SizedBox(height: screenHeight * 0.02 ),
                  Text(
                    "Need an account? Register",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
