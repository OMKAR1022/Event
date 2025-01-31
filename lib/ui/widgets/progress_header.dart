import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressHeader({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: Colors.blue.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 4,
          ),
          SizedBox(height: 8),
          Text(
            'Step $currentStep of $totalSteps',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

