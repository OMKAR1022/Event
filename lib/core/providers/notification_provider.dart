import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Notification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationProvider with ChangeNotifier {
  final List<Notification> _notifications = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  DateTime _lastCheckTime = DateTime.now();
  bool _isInitialized = false;

  List<Notification> get notifications => _notifications;
  bool get hasUnreadNotifications => _notifications.any((notification) => !notification.isRead);

  NotificationProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    await _initializeNotifications();
    await _loadSavedNotifications();
    _subscribeToEventChanges();

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _initializeNotifications() async {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? savedTime = prefs.getString('lastCheckTime');
    _lastCheckTime = savedTime != null ? DateTime.parse(savedTime) : DateTime.now();

    // Request permissions for iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request permissions for Android 13 and above
    if (await _isAndroid13OrHigher()) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        print('Notification tapped: ${notificationResponse.payload}');
      },
    );
  }

  Future<bool> _isAndroid13OrHigher() async {
    try {
      final androidInfo = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.getNotificationChannels();

      // This method is only available on Android 13 and above
      return androidInfo != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadSavedNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];

      _notifications.clear();
      _notifications.addAll(
          notificationsJson.map((json) => _notificationFromJson(json)).toList()
      );

      // Sort notifications by timestamp in descending order (newest first)
      _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      notifyListeners();
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  void _subscribeToEventChanges() {
    final supabase = Supabase.instance.client;
    supabase
        .from('event')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .listen((List<Map<String, dynamic>> events) async {
      await _handleNewEvents(events);
    });
  }

  Future<void> _handleNewEvents(List<Map<String, dynamic>> events) async {
    bool hasNewEvents = false;

    for (var event in events) {
      try {
        final createdAt = DateTime.parse(event['created_at']);

        // Only process events that were created after our last check
        if (createdAt.isAfter(_lastCheckTime)) {
          final notification = Notification(
            id: '${event['id']}_${createdAt.millisecondsSinceEpoch}',
            title: 'New Event Added',
            body: 'A new event "${event['title']}" has been added.',
            timestamp: createdAt,
          );

          // Check if notification already exists
          if (!_notifications.any((n) => n.id == notification.id)) {
            _notifications.insert(0, notification);
            await _showNotification(notification);
            hasNewEvents = true;
          }
        }
      } catch (e) {
        print('Error processing event: $e');
      }
    }

    if (hasNewEvents) {
      _lastCheckTime = DateTime.now();
      await _saveNotifications();
      notifyListeners();
    }
  }

  Future<void> _showNotification(Notification notification) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'event_notifications',
        'Event Notifications',
        channelDescription: 'Notifications for new events',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        notification.timestamp.millisecondsSinceEpoch ~/ 1000,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: notification.id,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final notification = _notifications.firstWhere((n) => n.id == notificationId);
    notification.isRead = true;
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = _notifications.map((n) => _notificationToJson(n)).toList();
      await prefs.setStringList('notifications', notificationsJson);
      await prefs.setString('lastCheckTime', _lastCheckTime.toIso8601String());
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  String _notificationToJson(Notification notification) {
    return jsonEncode({
      "id": notification.id,
      "title": notification.title,
      "body": notification.body,
      "timestamp": notification.timestamp.toIso8601String(),
      "isRead": notification.isRead
    });
  }

  Notification _notificationFromJson(String json) {
    final map = jsonDecode(json);
    return Notification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] ?? false,
    );
  }
}

