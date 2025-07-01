import 'package:cloud_firestore/cloud_firestore.dart'; 

class Event {
  final String id;
  final String title;
  final String location;
  final String category;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.date,
  });

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'],
      location: data['location'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(), 
    );
  }
}
