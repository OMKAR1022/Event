import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../core/providers/student_auth_provider.dart';

class StudentCreateAccountScreen extends StatefulWidget {
  @override
  _StudentCreateAccountScreenState createState() => _StudentCreateAccountScreenState();
}

class _StudentCreateAccountScreenState extends State<StudentCreateAccountScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _enrollmentController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _selectedDepartment = '';
  String _selectedYear = '1st';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final List<String> departments = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical',
    'Civil',
    'Electrical',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _enrollmentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        HapticFeedback.mediumImpact();
        await Provider.of<StudentAuthProvider>(context, listen: false).createAccount(
          name: _nameController.text,
          phoneNo: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          enrollNo: _enrollmentController.text,
          department: _selectedDepartment,
          className: _selectedYear,
        );
        Navigator.of(context).pop();
      } catch (e) {
        _showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      HapticFeedback.lightImpact();
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'title',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'Create Student Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please fill in your information below',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Material(
                                color: Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // TODO: Implement image picker
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      ..._buildFormFields(),
                      SizedBox(height: 32),
                      _buildSubmitButton(),
                      SizedBox(height: 24),
                      _buildSignInLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _buildFormField(
        label: 'Full Name',
        controller: _nameController,
        icon: Icons.person_outline,
        hintText: 'Enter your full name',
        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
      ),
      _buildFormField(
        label: 'Phone Number',
        controller: _phoneController,
        icon: Icons.phone_outlined,
        hintText: 'Enter your phone number',
        keyboardType: TextInputType.phone,
        validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
      ),
      _buildFormField(
        label: 'Email Address',
        controller: _emailController,
        icon: Icons.mail_outline,
        hintText: 'Enter your email',
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value!.isEmpty || !value.contains('@')
            ? 'Please enter a valid email'
            : null,
      ),
      _buildFormField(
        label: 'Password',
        controller: _passwordController,
        icon: Icons.lock_outline,
        hintText: 'Create password',
        obscureText: _obscurePassword,
        suffixIcon: _buildVisibilityToggle(_obscurePassword, (value) => setState(() => _obscurePassword = value)),
        validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
      ),
      _buildFormField(
        label: 'Confirm Password',
        controller: _confirmPasswordController,
        icon: Icons.lock_outline,
        hintText: 'Confirm password',
        obscureText: _obscureConfirmPassword,
        suffixIcon: _buildVisibilityToggle(_obscureConfirmPassword, (value) => setState(() => _obscureConfirmPassword = value)),
        validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
      ),
      _buildFormField(
        label: 'Enrollment Number',
        controller: _enrollmentController,
        icon: Icons.numbers_outlined,
        hintText: 'Enter enrollment number',
        validator: (value) => value!.isEmpty ? 'Please enter your enrollment number' : null,
      ),
      _buildDepartmentField(),
      _buildYearSelection(),
    ];
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[400]!, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[400]!, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: validator,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityToggle(bool obscureText, Function(bool) onChanged) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey[400],
          size: 22,
        ),
        splashRadius: 24,
        onPressed: () {
          HapticFeedback.selectionClick();
          onChanged(!obscureText);
        },
      ),
    );
  }

  Widget _buildDepartmentField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Department',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[50],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: _selectedDepartment.isEmpty ? null : _selectedDepartment,
                hint: Text('Select department', style: TextStyle(color: Colors.grey[400])),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.business_outlined, color: Colors.grey[400], size: 22),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                items: departments.map((String department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedDepartment = newValue!);
                },
                validator: (value) => value == null ? 'Please select a department' : null,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                isExpanded: true,
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Year',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: ['1st', '2nd', '3rd', '4th'].map((year) {
              final isSelected = _selectedYear == year;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: year != '4th' ? 8.0 : 0,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedYear = year);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Color(0xFF6366F1) : Colors.grey[100],
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ] : [],
                        ),
                        child: Center(
                          child: Text(
                            year,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6366F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: _isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6366F1),
            ),
          ),
        ),
      ],
    );
  }
}

