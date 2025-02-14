// qr_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData icon;
  final Color color_1;
  final Color color_2;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.icon,
    required this.color_1,
    required this.color_2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 1,
            offset: Offset(-2, 2), // Adjust to change the shadow position
          ),
        ],
        gradient: LinearGradient(
          colors: [color_1, color_2], // Customize your gradient colors here
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon,color: Colors.white,),
        label: Text(title),
        style: ElevatedButton.styleFrom(

          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
