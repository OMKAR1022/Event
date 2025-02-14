import 'package:flutter/material.dart';

import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/navigation_buttons.dart';


class StepThree extends StatelessWidget {
  final TextEditingController maxParticipantsController;
  final TextEditingController registrationDeadlineController;
  final bool enableWaitlist;
  final bool requireApproval;
  final VoidCallback onSelectDeadline;
  final Function(bool?) onWaitlistChanged;
  final Function(bool?) onApprovalChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepThree({
    Key? key,
    required this.maxParticipantsController,
    required this.registrationDeadlineController,
    required this.enableWaitlist,
    required this.requireApproval,
    required this.onSelectDeadline,
    required this.onWaitlistChanged,
    required this.onApprovalChanged,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Maximum Participants',
          hintText: 'Enter maximum limit',
          controller: maxParticipantsController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter maximum participants';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        SizedBox(height: 24),
        CustomTextField(
          label: 'Registration Deadline',
          hintText: 'DD/MM/YYYY, HH:MM PM',
          controller: registrationDeadlineController,
          readOnly: true,
          onTap: onSelectDeadline,
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select registration deadline';
            }
            return null;
          },
        ),
        SizedBox(height: 24),
        _buildCheckboxTile(
          title: 'Enable waitlist',
          value: enableWaitlist,
          onChanged: onWaitlistChanged,
        ),
        _buildCheckboxTile(
          title: 'Require approval',
          value: requireApproval,
          onChanged: onApprovalChanged,
        ),
        SizedBox(height: 32),
        NavigationButtons(
          onNext: onNext,
          onBack: onBack,
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.blue,
      ),
    );
  }
}

