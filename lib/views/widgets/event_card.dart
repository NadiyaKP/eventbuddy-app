import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  // EventBuddy Color Theme (matching the main app theme)
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color secondaryPurple = Color(0xFF8E44AD);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  // Category colors and icons mapping
  Map<String, Map<String, dynamic>> get categoryData => {
    'Tech': {
      'color': primaryBlue,
      'gradient': [Color(0xFF4A90E2), Color(0xFF357ABD)],
      'icon': Icons.computer,
      'bgColor': Color(0xFFE3F2FD),
    },
    'Sports': {
      'color': successGreen,
      'gradient': [Color(0xFF27AE60), Color(0xFF229954)],
      'icon': Icons.sports_soccer,
      'bgColor': Color(0xFFE8F5E8),
    },
    'Culture': {
      'color': secondaryPurple,
      'gradient': [Color(0xFF8E44AD), Color(0xFF7D3C98)],
      'icon': Icons.palette,
      'bgColor': Color(0xFFF3E5F5),
    },
    'Music': {
      'color': accentOrange,
      'gradient': [Color(0xFFFF6B35), Color(0xFFE55A2B)],
      'icon': Icons.music_note,
      'bgColor': Color(0xFFFFF3E0),
    },
  };

  bool get isUpcoming => event.date.isAfter(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    final eventDate = event.date;
    return eventDate.year == now.year &&
           eventDate.month == now.month &&
           eventDate.day == now.day;
  }

  String get formattedDate {
    final now = DateTime.now();
    final eventDate = event.date;
    
    if (isToday) {
      return 'Today • ${DateFormat('h:mm a').format(eventDate)}';
    } else if (eventDate.difference(now).inDays == 1) {
      return 'Tomorrow • ${DateFormat('h:mm a').format(eventDate)}';
    } else if (eventDate.difference(now).inDays == -1) {
      return 'Yesterday • ${DateFormat('h:mm a').format(eventDate)}';
    } else {
      return DateFormat('MMM dd, yyyy • h:mm a').format(eventDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = categoryData[event.category] ?? categoryData['Tech']!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: category['color'].withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with category indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      category['bgColor'].withOpacity(0.3),
                      category['bgColor'].withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    // Category Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: category['gradient'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: category['color'].withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        category['icon'],
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Event Title and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: category['color'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  event.category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: accentOrange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'TODAY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Status Indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isUpcoming ? successGreen : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Event Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Date and Time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: primaryBlue,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isToday ? accentOrange : textPrimary,
                                ),
                              ),
                              Text(
                                isUpcoming ? 'Upcoming Event' : 'Past Event',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Location
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: successGreen,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Event Location',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Action Button
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: category['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: category['color'],
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
