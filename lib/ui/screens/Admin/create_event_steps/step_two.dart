import 'package:flutter/material.dart';
import '../../../widgets/form/custom_text_field.dart';
import '../../../widgets/navigation_buttons.dart';

class StepTwo extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController venueController;
  final VoidCallback onSelectDate;
  final Function(TextEditingController) onSelectTime;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepTwo({
    Key? key,
    required this.dateController,
    required this.startTimeController,
    required this.endTimeController,
    required this.venueController,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Event Date',
          hintText: 'DD/MM/YYYY',
          controller: dateController,
          readOnly: true,
          onTap: onSelectDate,
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Start Time',
                hintText: '12:30 PM',
                controller: startTimeController,
                readOnly: true,
                onTap: () => onSelectTime(startTimeController),
                suffixIcon: Icon(Icons.access_time, color: Colors.grey),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'End Time',
                hintText: '12:30 PM',
                controller: endTimeController,
                readOnly: true,
                onTap: () => onSelectTime(endTimeController),
                suffixIcon: Icon(Icons.access_time, color: Colors.grey),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        CustomTextField(
          label: 'Venue',
          hintText: 'Enter venue',
          controller: venueController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a venue';
            }
            return null;
          },
        ),
        SizedBox(height: 32),
        NavigationButtons(
          onNext: onNext,
          onBack: onBack,
        ),
      ],
    );
  }
}

