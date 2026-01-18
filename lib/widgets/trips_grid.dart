import 'package:flutter/cupertino.dart';
import 'package:trip_planner/models/trip.dart';
import 'package:trip_planner/widgets/trip_card.dart';

class TripsGrid extends StatelessWidget {
  final List<Trip> trips;
  final Function(Trip trip) onTap;
  
  const TripsGrid({super.key, required this.trips, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          // Mobile: 1 column
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          // Tablet: 2 columns
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1200) {
          // Small desktop: 3 columns
          crossAxisCount = 3;
        } else {
          // Large desktop: 4 columns
          crossAxisCount = 4;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.85,
          ),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return TripCard(
              trip: trip,
              onTap: () => onTap(trip),
            );
          },
        );
      },
    );
  }
}
