import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import '../services/navigation_service.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final int tripId;
  final Trip? trip; // Optional trip object for backward compatibility

  const TripDetailScreen({super.key, required this.tripId, this.trip});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  final ApiService _apiService = ApiService();

  void _editTrip(BuildContext context, int tripId) async {
    final result = await NavigationService().navigateToEditTrip(context, tripId);
    if (result == true) {
      ref.read(tripDetailsProvider(widget.tripId).notifier).refresh();
    }
  }

  void _addPlan(BuildContext context, int tripId) async {
    final result = await NavigationService().navigateToCreatePlan(context, tripId);
    if (result == true) {
      ref.read(tripDetailsProvider(widget.tripId).notifier).refresh();
    }
  }

  void _navigateToPlanDetail(BuildContext context, int planId) async {
    final result = await NavigationService().navigateToPlanDetail(context, widget.tripId, planId);
    if (result == true) {
      ref.read(tripDetailsProvider(widget.tripId).notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailsProvider(widget.tripId));

    return tripAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: const Toolbar(title: 'Trip Details'),
        body: Center(child: Text('Error: $error')),
      ),
      data: (trip) {
        if (trip == null) {
          return const Scaffold(
            appBar: Toolbar(title: 'Trip Details'),
            body: Center(child: Text('No trip data found')),
          );
        }
        return Scaffold(
          appBar: Toolbar(
            title: trip.name,
            allowBackNavigation: true,
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
                child: (trip.plans == null || trip.plans!.isEmpty)
                    ? const Center(child: Text('No plans yet.'))
                    : ListView.builder(
                        itemCount: trip.plans!.length,
                        itemBuilder: (context, index) {
                          final plan = trip.plans![index];
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
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addPlan(context, trip.id),
            child: const Icon(Icons.add),
          ),
        );
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
        NavigationService().navigateToTrips(context);
      }
    }
  }
}