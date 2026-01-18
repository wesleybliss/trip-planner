import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/api_service.dart';

class EditTripScreen extends StatefulWidget {
  final Trip trip;

  const EditTripScreen({super.key, required this.trip});

  @override
  EditTripScreenState createState() => EditTripScreenState();
}

class EditTripScreenState extends State<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _name = widget.trip.name;
    _description = widget.trip.description ?? '';
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final updatedTrip = widget.trip.copyWith(
          name: _name,
          description: _description,
        );
        await _apiService.updateTrip(updatedTrip);
        if (mounted) {
          Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Trip')),
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
}
