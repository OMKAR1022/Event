import 'package:flutter/material.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/club_profile_provider.dart';

import '../../../../core/providers/login_provider.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> _isEmailAlreadyRegistered(String email) async {
    final authProvider = Provider.of<LoginProvider>(context, listen: false);
    return await authProvider.isEmailRegistered(email);
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = Provider.of<ClubProfileProvider>(context).currentUser?['email'] ?? 'No email set';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[100]!, Colors.grey[50]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email Icon Container
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 40,
                    color: AppColors.primery,
                  ),
                ),
                SizedBox(height: 40),

                // Title
                Text(
                  'Change Email Address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),

                // Current Email Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Your current Email Address is: ',
                        style: TextStyle(
                          fontSize:10,
                          color: Colors.grey[700],
                        ),
                        children: [
                          TextSpan(
                            text: currentEmail,
                            style: TextStyle(
                                color: AppColors.primery,
                                fontWeight: FontWeight.w500,
                                fontSize: 10
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primery,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter New Email Address',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primery),
                          ),
                          errorText: _errorMessage,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          if (value == currentEmail) {
                            return 'The new email cannot be the same as your current email.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final newEmail = _emailController.text;
                            final isRegistered = await _isEmailAlreadyRegistered(newEmail);
                            if (isRegistered) {
                              setState(() {
                                _errorMessage = 'This email is already registered with another user.';
                              });
                            } else {
                              try {
                                await Provider.of<ClubProfileProvider>(context, listen: false)
                                    .updateEmail(newEmail);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Email updated successfully')),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update email: $e')),
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          'Change Email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primery,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

