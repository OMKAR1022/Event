class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizerId;
  final int maxParticipants;
  final List<String> registeredUsers;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizerId,
    required this.maxParticipants,
    required this.registeredUsers,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      organizerId: json['organizer_id'],
      maxParticipants: json['max_participants'],
      registeredUsers: List<String>.from(json['registered_users'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'organizer_id': organizerId,
      'max_participants': maxParticipants,
      'registered_users': registeredUsers,
    };
  }
}

