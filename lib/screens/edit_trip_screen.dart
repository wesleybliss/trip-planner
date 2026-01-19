import 'package:flutter/material.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import '../models/trip.dart';
import '../services/api_service.dart';

class EditTripScreen extends StatefulWidget {
  final int tripId;
  final Trip? trip; // For backward compatibility

  const EditTripScreen({super.key, required this.tripId, this.trip});

  @override
  EditTripScreenState createState() => EditTripScreenState();
}

class EditTripScreenState extends State<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late Future<Trip> _tripFuture;
  late String _name;
  late String _description;

  @override
  void initState() {
    super.initState();
    _tripFuture = _apiService.getTrip(widget.tripId);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // First get the current trip data
        final currentTrip = await _tripFuture;
        final updatedTrip = currentTrip.copyWith(
          name: _name,
          description: _description,
        );
        await _apiService.updateTrip(updatedTrip);
        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to update trip: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Trip>(
      future: _tripFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: Toolbar(title: 'Edit Trip', allowBackNavigation: true),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: const Toolbar(title: 'Edit Trip', allowBackNavigation: true),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: const Toolbar(title: 'Edit Trip', allowBackNavigation: true),
            body: const Center(child: Text('No trip data available')),
          );
        } else {
          final trip = snapshot.data!;
          // Initialize form fields with trip data
          _name = trip.name;
          _description = trip.description ?? '';

          return Scaffold(
            appBar: const Toolbar(title: 'Edit Trip', allowBackNavigation: true),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(labelText: 'Trip Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a trip name' : null,
                      onSaved: (value) => _name = value!,
                    ),
                    TextFormField(
                      initialValue: _description,
                      decoration: const InputDecoration(labelText: 'Description'),
                      onSaved: (value) => _description = value!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Update Trip'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
