import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/trip.dart';
import 'plan_detail_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: FutureBuilder<Trip>(
        future: _apiService.getTrip(widget.tripId, withDetails: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Trip not found.'));
          } else {
            final trip = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8.0),
                  Text(trip.description ?? ''),
                  const SizedBox(height: 16.0),
                  if (trip.plans != null)
                    ...trip.plans!.map((plan) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(plan.name, style: Theme.of(context).textTheme.headlineSmall),
                          subtitle: Text(plan.description ?? ''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanDetailScreen(plan: plan),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
