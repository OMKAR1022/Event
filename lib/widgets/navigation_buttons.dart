import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final String nextLabel;
  final bool showBack;

  const NavigationButtons({
    Key? key,
    required this.onNext,
    this.onBack,
    this.nextLabel = 'Next',
    this.showBack = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBack && onBack != null)
          TextButton(
            onPressed: onBack,
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          )
        else
          SizedBox.shrink(),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            nextLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

