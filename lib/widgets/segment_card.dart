import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/segment.dart';

class SegmentCard extends StatelessWidget {
  final int tripId;
  final Segment segment;
  final Function(BuildContext context, int segmentId) editSegment;
  final Function(Segment segment, int tripId) deleteSegment;
  
  const SegmentCard({super.key, required this.tripId, required this.segment, required this.editSegment, required this.deleteSegment});
  
  @override
  Widget build(BuildContext context) {
    final duration = segment.endDate.difference(segment.startDate).inDays;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  segment.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      editSegment(context, segment.id);
                    } else if (value == 'delete') {
                      deleteSegment(segment, tripId);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16.0),
                const SizedBox(width: 8.0),
                Text(
                  '${DateFormat.yMMMd().format(segment.startDate)} - ${DateFormat.yMMMd().format(segment.endDate)} ($duration days)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.place, size: 16.0),
                const SizedBox(width: 8.0),
                Text(
                  segment.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
