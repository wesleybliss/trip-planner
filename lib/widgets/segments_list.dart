import 'package:flutter/material.dart';
import 'package:trip_planner/models/place.dart';
import 'package:trip_planner/models/segment.dart';
import 'package:trip_planner/widgets/segment_card.dart';

class SegmentsList extends StatelessWidget {
  final int tripId;
  final List<Segment>? segments;
  final List<Place>? places;
  final Function(BuildContext context, int segmentId) editSegment;
  final Function(Segment segment, int tripId) deleteSegment;

  const SegmentsList({super.key, required this.tripId, required this.segments, this.places, required this.editSegment, required this.deleteSegment});
  
  @override
  Widget build(BuildContext context) {
    if (segments == null || segments?.isEmpty == true) {
      // ... (rest of the empty state)
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final segment = segments![index];
        final place = places?.where((p) => p.name == segment.name).firstOrNull;
        
        return SegmentCard(
            tripId: tripId,
            segment: segment,
            imageUrl: place?.coverImageUrl,
            editSegment: editSegment,
            deleteSegment: deleteSegment);
      }, childCount: segments!.length),
    );
  }
}
