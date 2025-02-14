import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/event_creation_provider.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/navigation_buttons.dart';

class StepFour extends StatelessWidget {
  final TextEditingController additionalNotesController;
  final File? selectedImage;
  final Function(File) onImageSelected;
  final VoidCallback onBack;
  final Map<String, dynamic> eventData;

  const StepFour({
    Key? key,
    required this.additionalNotesController,
    required this.selectedImage,
    required this.onImageSelected,
    required this.onBack,
    required this.eventData,
  }) : super(key: key);

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (image != null) {
      onImageSelected(File(image.path));
    }
  }

  void _handleCreateEvent(BuildContext context) async {
    final provider = Provider.of<EventCreationProvider>(context, listen: false);

    try {
      await provider.createEvent(
        title: eventData['title'],
        description: eventData['description'],
        category: eventData['category'],
        date: eventData['date'],
        startTime: eventData['startTime'],
        endTime: eventData['endTime'],
        venue: eventData['venue'],
        maxParticipants: eventData['maxParticipants'],
        registrationDeadline: eventData['registrationDeadline'],
        enableWaitlist: eventData['enableWaitlist'],
        requireApproval: eventData['requireApproval'],
        additionalNotes: additionalNotesController.text,
        clubId: eventData['clubId'],
        bannerImage: selectedImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully!')),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Banner',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        _buildImageUploader(),
        SizedBox(height: 24),
        CustomTextField(
          label: 'Additional Notes',
          hintText: 'Any additional information',
          controller: additionalNotesController,
          maxLines: 4,
        ),
        SizedBox(height: 32),
        Consumer<EventCreationProvider>(
          builder: (context, provider, child) {
            return NavigationButtons(
              onNext: () => _handleCreateEvent(context),
              onBack: onBack,
              nextLabel: 'Create Event',
             // isNextEnabled: !provider.isLoading,
            );
          },
        ),
      ],
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: selectedImage == null ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 8),
            Text(
              'Upload a file',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'PNG, JPG up to 10MB',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                selectedImage!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

