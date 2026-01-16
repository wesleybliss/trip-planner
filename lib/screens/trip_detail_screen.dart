import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/plan.dart';
import '../services/api_service.dart';
import '../models/trip.dart';
import 'plan_detail_screen.dart';
import 'edit_trip_screen.dart';
import 'create_plan_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;

  const TripDetailScreen({super.key, required this.tripId});

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

  void _editTrip(Trip trip) async {
    final updatedTrip = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTripScreen(trip: trip),
      ),
    );
    if (updatedTrip != null) {
      await _apiService.updateTrip(updatedTrip);
      setState(() {
        _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
      });
    }
  }

  void _deleteTrip(int tripId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: const Text('Are you sure you want to delete this trip? This action cannot be undone.'),
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
        Navigator.pop(context);
      }
    }
  }

  void _addPlan(int tripId) async {
    final newPlan = await Navigator.push<Plan>(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePlanScreen(tripId: tripId),
      ),
    );
    if (newPlan != null) {
      await _apiService.createPlan(newPlan);
      setState(() {
        _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Trip>(
      future: _tripFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Trip not found.')),
          );
        } else {
          final trip = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(trip.name),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editTrip(trip);
                    } else if (value == 'delete') {
                      _deleteTrip(trip.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
            body: ListView(
              children: [
                _buildTripHeader(context, trip),
                const SizedBox(height: 16.0),
                _buildPlansSection(context, trip, trip.plans),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addPlan(trip.id),
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  Widget _buildTripHeader(BuildContext context, Trip trip) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.name,
            style: GoogleFonts.oswald(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            trip.description ?? 'No description provided.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                '${trip.plans?.length ?? 0} plans',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlansSection(BuildContext context, Trip trip, List<Plan>? plans) {
    if (plans == null || plans.isEmpty) {
      return const Center(
        child: Text('No plans for this trip yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Plans',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanDetailScreen(plan: plan),
                    ),
                  ).then((_) {
                    setState(() {
                       _tripFuture = _apiService.getTrip(widget.tripId, withDetails: true);
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        plan.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           Text(
                            '${plan.segments?.length ?? 0} segments',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(width: 8.0),
                          const Icon(Icons.arrow_forward_ios, size: 14.0),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
