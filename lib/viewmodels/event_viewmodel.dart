import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventViewModel with ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  List<Event> get events => _filteredEvents;

  Future<void> loadEvents() async {
    _allEvents = await _eventService.fetchEvents();
    _filteredEvents = List.from(_allEvents);
    notifyListeners();
  }

  void searchEvents(String query) {
    _filteredEvents = _allEvents.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
             event.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _filteredEvents = _allEvents.where((event) => event.category == category).toList();
    notifyListeners();
  }

  void sortBy(String type) {
    if (type == 'Date') {
      _filteredEvents.sort((a, b) => a.date.compareTo(b.date));
    } else if (type == 'Name') {
      _filteredEvents.sort((a, b) => a.title.compareTo(b.title));
    }
    notifyListeners();
  }
}
