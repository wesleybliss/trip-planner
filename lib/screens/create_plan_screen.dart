import 'package:flutter/material.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import '../models/plan.dart';
import '../services/api_service.dart';

class CreatePlanScreen extends StatefulWidget {
  final int tripId;

  const CreatePlanScreen({super.key, required this.tripId});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Toolbar(title: 'Create Plan', allowBackNavigation: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Plan Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a plan name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newPlan = Plan(
                        id: 0,
                        tripId: widget.tripId,
                        name: _nameController.text,
                        description: _descriptionController.text,
                      );
                      final navigator = Navigator.of(context);
                      await _apiService.createPlan(newPlan);
                      if (!mounted) return;
                      navigator.pop(true);
                    }
                  },
                  child: const Text('Create Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
