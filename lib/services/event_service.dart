import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final _db = FirebaseFirestore.instance;

  Future<List<Event>> fetchEvents() async {
    final snapshot = await _db.collection('events').get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList();
  }
}