import 'package:flutter/material.dart';
import '../../../widgets/form/custom_text_field.dart';
import '../../../widgets/form/custom_dropdown.dart';
import '../../../widgets/navigation_buttons.dart';

class StepOne extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String selectedCategory;
  final List<String> categories;
  final Function(String?) onCategoryChanged;
  final VoidCallback onNext;

  const StepOne({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Event Title',
          hintText: 'Enter event title',
          controller: titleController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an event title';
            }
            return null;
          },
        ),
        SizedBox(height: 24),
        CustomDropdown(
          label: 'Category',
          value: selectedCategory,
          items: categories,
          onChanged: onCategoryChanged,
        ),
        SizedBox(height: 24),
        CustomTextField(
          label: 'Description',
          hintText: 'Describe your event',
          controller: descriptionController,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an event description';
            }
            return null;
          },
        ),
        SizedBox(height: 32),
        NavigationButtons(
          onNext: onNext,
          showBack: false,
        ),
      ],
    );
  }
}

