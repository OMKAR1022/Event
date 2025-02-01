import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class EventCreationProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createEvent({
    required String title,
    required String description,
    required String category,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String venue,
    required int maxParticipants,
    required DateTime registrationDeadline,
    required bool enableWaitlist,
    required bool requireApproval,
    required String additionalNotes,
    required String clubId,
    File? bannerImage,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      String? imageUrl;
      if (bannerImage != null) {
        imageUrl = await _uploadEventBanner(bannerImage, clubId);
      }

      // Convert TimeOfDay to String in HH:mm format
      final startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

      final eventData = {
        'title': title,
        'description': description,
        'category': category,
        'date': date.toIso8601String().split('T')[0], // Just the date part
        'start_time': startTimeStr,
        'end_time': endTimeStr,
        'venue': venue,
        'status': 'upcoming',
        'image_url': imageUrl,
        'max_participants': maxParticipants,
        'registration_deadline': registrationDeadline.toIso8601String().split('T')[0], // Just the date part
        'enable_waitlist': enableWaitlist,
        'require_approval': requireApproval,
        'additional_notes': additionalNotes,
        'club_id': clubId, // Keep clubId as a string since it's a UUID
      };

      print('Event data to be inserted: $eventData');

      // Insert the event data into the 'event' table
      await _supabase
          .from('event')
          .insert(eventData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create event: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> _uploadEventBanner(File image, String clubId) async {
    try {
      final fileExt = image.path.split('.').last;
      final fileName = '${clubId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'event_banners/$clubId/$fileName';

      // Upload the file with specific metadata
      final fileOptions = FileOptions(
        upsert: false,
        contentType: 'image/$fileExt',
        cacheControl: '3600',
      );

      await _supabase
          .storage
          .from('event_banners')
          .upload(filePath, image, fileOptions: fileOptions);

      // Get the public URL
      final imageUrl = _supabase
          .storage
          .from('event_banners')
          .getPublicUrl(filePath);

      return imageUrl;
    } on StorageException catch (e) {
      throw 'Failed to upload image: ${e.message}';
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }
}

