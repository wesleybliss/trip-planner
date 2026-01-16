import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../models/plan.dart';
import '../services/api_service.dart';
import 'edit_trip_screen.dart';
import 'create_plan_screen.dart';
import 'plan_detail_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Plan>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _plansFuture = _apiService.getPlans(widget.trip.id);
  }

  void _editTrip(Trip trip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTripScreen(trip: trip),
      ),
    );
    if (result == true) {
      setState(() {
        // Reload trip details if needed
      });
    }
  }

  void _addPlan(int tripId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePlanScreen(tripId: tripId),
      ),
    );
    if (result == true) {
      setState(() {
        _plansFuture = _apiService.getPlans(widget.trip.id);
      });
    }
  }

  void _navigateToPlanDetail(Plan plan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetailScreen(plan: plan),
      ),
    );
    if (result == true) {
      setState(() {
        _plansFuture = _apiService.getPlans(widget.trip.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTrip(widget.trip),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTrip(widget.trip.id),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.trip.description ?? 'No description provided.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Plans',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Plan>>(
              future: _plansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No plans yet.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final plan = snapshot.data![index];
                      return ListTile(
                        title: Text(plan.name),
                        subtitle: Text('${DateFormat.yMMMd().format(plan.startDate)} - ${DateFormat.yMMMd().format(plan.endDate)}'),
                        onTap: () => _navigateToPlanDetail(plan),
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
        onPressed: () => _addPlan(widget.trip.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteTrip(int tripId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: const Text(
            'Are you sure you want to delete this trip? This action cannot be undone.'),
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
        Navigator.pop(context, true);
      }
    }
  }
}
