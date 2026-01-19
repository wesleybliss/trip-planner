import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../models/plan.dart';
import '../services/api_service.dart';
import '../services/navigation_service.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;
  final Trip? trip; // Optional trip object for backward compatibility

  const TripDetailScreen({super.key, required this.tripId, this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Trip> _tripFuture;

  @override
  void initState() {
    super.initState();
    _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
  }

  void _editTrip(BuildContext context, int tripId) async {
    /*final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTripScreen(tripId: tripId)),
    );*/
    final result = await NavigationService().navigateToEditTrip(context, tripId);
    if (result == true) {
      setState(() {
        // Reload trip details and plans
        _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
      });
    }
  }

  void _addPlan(BuildContext context, int tripId) async {
    /*final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePlanScreen(tripId: tripId)),
    );*/
    final result = await NavigationService().navigateToCreatePlan(context, tripId);
    if (result == true) {
      setState(() {
        _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
      });
    }
  }

  void _navigateToPlanDetail(BuildContext context, int planId) async {
    /*final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanDetailScreen(planId: planId)),
    );*/
    final result = await NavigationService().navigateToPlanDetail(context, planId);
    if (result == true) {
      setState(() {
        _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Trip>(
      future: _tripFuture,
      builder: (context, tripSnapshot) {
        if (tripSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (tripSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Trip Details')),
            body: Center(child: Text('Error: ${tripSnapshot.error}')),
          );
        } else if (!tripSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Trip Details')),
            body: const Center(child: Text('No trip data found')),
          );
        } else {
          final trip = tripSnapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(trip.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTrip(context, trip.id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTrip(trip.id),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    trip.description ?? 'No description provided.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Plans',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<Trip>(
                    future: _tripFuture,
                    builder: (context, plansSnapshot) {
                      if (tripSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (tripSnapshot.hasError) {
                        return Center(child: Text('Error: ${tripSnapshot.error}'));
                      } else if (!tripSnapshot.hasData || tripSnapshot.data?.plans?.isEmpty == true) {
                        return const Center(child: Text('No plans yet.'));
                      } else {
                        final plans = tripSnapshot.data!.plans!;
                        return ListView.builder(
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            final plan = plans[index];
                            return ListTile(
                              title: Text(plan.name),
                              subtitle: Text(
                                (plan.startDate != null && plan.endDate != null)
                                    ? '${DateFormat.yMMMd().format(plan.startDate!)} - ${DateFormat.yMMMd().format(plan.endDate!)}'
                                    : 'Dates TBD',
                              ),
                              onTap: () => _navigateToPlanDetail(context, plan.id),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addPlan(context, trip.id),
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  void _deleteTrip(int tripId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: const Text(
          'Are you sure you want to delete this trip? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _apiService.deleteTrip(tripId);
      if (mounted) {
        //Navigator.pop(context, true);
        NavigationService().navigateToTrips(context);
      }
    }
  }
}
