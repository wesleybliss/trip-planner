import 'package:flutter/material.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import 'package:trip_planner/widgets/trips_grid.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import '../services/navigation_service.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = _apiService.getTrips();
  }

  void _addTrip(BuildContext context) async {
    final result = await NavigationService().navigateToCreateTrip(context);
    if (result == true) {
      setState(() {
        _tripsFuture = _apiService.getTrips();
      });
    }
  }

  void _navigateToTripDetail(BuildContext context, int tripId) async {
    final result = await NavigationService().navigateToTripDetail(context, tripId);
    if (result == true) {
      setState(() {
        _tripsFuture = _apiService.getTrips();
      });
    }
  }

  void _signOut() async {
    await _apiService.signOut();
    if (mounted) {
      NavigationService().navigateToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: 'My Trips',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: FutureBuilder<List<Trip>>(
        future: _tripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_travel, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No trips yet!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Click the + button to add your first trip.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return TripsGrid(
              trips: snapshot.data!,
              onTap: (trip) => _navigateToTripDetail(context, trip.id),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTrip(context),
        tooltip: 'Add Trip',
        child: const Icon(Icons.add),
      ),
    );
  }
}
