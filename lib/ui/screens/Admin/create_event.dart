import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../core/providers/event_creation_provider.dart';
import '../../widgets/progress_header.dart';
import 'create_event_steps/step_one.dart';
import 'create_event_steps/step_two.dart';
import 'create_event_steps/step_three.dart';
import 'create_event_steps/step_four.dart';

class CreateEventScreen extends StatefulWidget {
  final String clubId;

  const CreateEventScreen({Key? key, required this.clubId}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;
  final int _totalSteps = 4;

  // Step 1 controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Academic';

  // Step 2 controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  // Step 3 controllers
  final TextEditingController _maxParticipantsController = TextEditingController();
  final TextEditingController _registrationDeadlineController = TextEditingController();
  bool _enableWaitlist = false;
  bool _requireApproval = false;

  // Step 4 controllers
  final TextEditingController _additionalNotesController = TextEditingController();
  File? _selectedImage;

  final List<String> _categories = [
    'Academic',
    'Cultural',
    'Sports',
    'Technical',
    'Workshop',
    'Other'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _venueController.dispose();
    _maxParticipantsController.dispose();
    _registrationDeadlineController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Store time in 24-hour format
        controller.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _registrationDeadlineController.text = combinedDateTime.toIso8601String();
        });
      }
    }
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_currentStep < _totalSteps) {
          _currentStep++;
        }
      });
    }
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      }
    });
  }

  void _handleCreateEvent() async {
    if (_formKey.currentState!.validate()) {
      final eventCreationProvider = Provider.of<EventCreationProvider>(context, listen: false);

      try {
        await eventCreationProvider.createEvent(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          date: DateTime.parse(_dateController.text),
          startTime: TimeOfDay(
            hour: int.parse(_startTimeController.text.split(':')[0]),
            minute: int.parse(_startTimeController.text.split(':')[1]),
          ),
          endTime: TimeOfDay(
            hour: int.parse(_endTimeController.text.split(':')[0]),
            minute: int.parse(_endTimeController.text.split(':')[1]),
          ),
          venue: _venueController.text,
          maxParticipants: int.parse(_maxParticipantsController.text),
          registrationDeadline: DateTime.parse(_registrationDeadlineController.text),
          enableWaitlist: _enableWaitlist,
          requireApproval: _requireApproval,
          additionalNotes: _additionalNotesController.text,
          clubId: widget.clubId,
          bannerImage: _selectedImage,
        );

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back or to another screen
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create event: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _getCurrentStep() {
    switch (_currentStep) {
      case 1:
        return StepOne(
          titleController: _titleController,
          descriptionController: _descriptionController,
          selectedCategory: _selectedCategory,
          categories: _categories,
          onCategoryChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
          onNext: _nextStep,
        );
      case 2:
        return StepTwo(
          dateController: _dateController,
          startTimeController: _startTimeController,
          endTimeController: _endTimeController,
          venueController: _venueController,
          onSelectDate: () => _selectDate(context),
          onSelectTime: _selectTime,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 3:
        return StepThree(
          maxParticipantsController: _maxParticipantsController,
          registrationDeadlineController: _registrationDeadlineController,
          enableWaitlist: _enableWaitlist,
          requireApproval: _requireApproval,
          onSelectDeadline: _selectDeadline,
          onWaitlistChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _enableWaitlist = value;
              });
            }
          },
          onApprovalChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _requireApproval = value;
              });
            }
          },
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 4:
        return StepFour(
          additionalNotesController: _additionalNotesController,
          selectedImage: _selectedImage,
          onImageSelected: (File image) {
            setState(() {
              _selectedImage = image;
            });
          },
          onBack: _previousStep,
          eventData: {
            'title': _titleController.text,
            'description': _descriptionController.text,
            'category': _selectedCategory,
            'date': DateTime.parse(_dateController.text),
            'startTime': TimeOfDay(
                hour: int.parse(_startTimeController.text.split(':')[0]),
                minute: int.parse(_startTimeController.text.split(':')[1])
            ),
            'endTime': TimeOfDay(
                hour: int.parse(_endTimeController.text.split(':')[0]),
                minute: int.parse(_endTimeController.text.split(':')[1])
            ),
            'venue': _venueController.text,
            'maxParticipants': int.parse(_maxParticipantsController.text),
            'registrationDeadline': DateTime.parse(_registrationDeadlineController.text.split(', ')[0]),
            'enableWaitlist': _enableWaitlist,
            'requireApproval': _requireApproval,
            'clubId': widget.clubId,
          },
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressHeader(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: _getCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Create New Event',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Implement preview functionality
          },
          child: Text(
            'Preview',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

