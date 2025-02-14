import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/login_provider.dart';
import 'student_create_account.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isClubMember = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15,
                      backgroundImage: NetworkImage(
                        'https://static.toiimg.com/thumb/msid-70529568,width-400,resizemode-4/70529568.jpg',
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "MIT ADT",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Event Management System",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  _buildToggleButton(),
                  SizedBox(height: screenHeight * 0.03),
                  _buildTextField(
                    controller: usernameController,
                    label: isClubMember ? 'Email' : 'Enrollment Number',
                    icon: Icons.person,
                    textCapitalization: isClubMember ? TextCapitalization.none : TextCapitalization.characters,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Forgot password functionality coming soon')),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildLoginButton(),
                  SizedBox(height: screenHeight * 0.01),
                  Divider(),
                  SizedBox(height: screenHeight * 0.01),
                  if (isClubMember)
                    _buildClubRegistration()
                  else
                    _buildStudentRegistration(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentRegistration() {
    return Column(
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentCreateAccountScreen()),
            );
          },
          child: Text(
            "Create student Account",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blue[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClubRegistration() {
    return Column(
      children: [
        Text(
          "New to College Events?",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Register your club to start creating events",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            // TODO: Implement club registration navigation
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue[600], side: BorderSide(color: Colors.blue[600]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: Text(
            "Register as Club",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isClubMember = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isClubMember ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: !isClubMember
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'student',
                    style: TextStyle(
                      fontWeight: !isClubMember ? FontWeight.bold : FontWeight.normal,
                      color: !isClubMember ? Colors.blue[700] : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isClubMember = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isClubMember ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isClubMember
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Club Member',
                    style: TextStyle(
                      fontWeight: isClubMember ? FontWeight.bold : FontWeight.normal,
                      color: isClubMember ? Colors.blue[700] : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        final username = usernameController.text.trim();
        final password = passwordController.text.trim();
        final authProvider = Provider.of<LoginProvider>(context, listen: false);

        setState(() => isLoading = true);

        try {
          if (isClubMember) {
            await authProvider.login(username, password, context);
          } else {
            await authProvider.loginStudent(username, password, context);
          }
        } finally {
          setState(() => isLoading = false);
        }
      },
      child: Container(
        width: double.infinity,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

