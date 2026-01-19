import 'package:flutter/material.dart';
import 'package:trip_planner/models/segment.dart';
import 'package:trip_planner/widgets/segment_card.dart';

class SegmentsList extends StatelessWidget {
  final int tripId;
  final List<Segment>? segments;
  final Function(BuildContext context, int segmentId) editSegment;
  final Function(Segment segment, int tripId) deleteSegment;

  const SegmentsList({super.key, required this.tripId, required this.segments, required this.editSegment, required this.deleteSegment});
  
  @override
  Widget build(BuildContext context) {
    if (segments == null || segments?.isEmpty == true) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: [
                const Icon(
                  Icons.luggage_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No segments yet!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your first travel segment to this plan.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return SegmentCard(
            tripId: tripId,
            segment: segments![index],
            editSegment: editSegment,
            deleteSegment: deleteSegment);
      }, childCount: segments!.length),
    );
  }
}
