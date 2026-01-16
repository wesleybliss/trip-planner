import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/segment.dart';
import '../models/place.dart';

class CreateSegmentScreen extends StatefulWidget {
  final int tripId;
  final int planId;

  const CreateSegmentScreen({super.key, required this.tripId, required this.planId});

  @override
  State<CreateSegmentScreen> createState() => _CreateSegmentScreenState();
}

class _CreateSegmentScreenState extends State<CreateSegmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final initialDate = isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? _startDate ?? DateTime.now());
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = newDate;
        } else {
          _endDate = newDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Segment'),
      ),
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
                  labelText: 'Segment Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a segment name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, isStartDate: true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_startDate != null ? DateFormat.yMMMd().format(_startDate!) : 'Select Date'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, isStartDate: false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_endDate != null ? DateFormat.yMMMd().format(_endDate!) : 'Select Date'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'Place',
                  border: OutlineInputBorder(),
                ),
                 validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a place';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
                      final newSegment = Segment(
                        id: 0, // Id will be assigned by the backend
                        tripId: widget.tripId,
                        planId: widget.planId,
                        name: _nameController.text,
                        startDate: _startDate!,
                        endDate: _endDate!,
                        place: Place(id: 0, name: _placeController.text, type: 'City'), // Id and type are hardcoded for now
                        color: '#FF0000', // Hardcoded for now
                        flightBooked: false, // Hardcoded for now
                        stayBooked: false, // Hardcoded for now
                        isShengenRegion: false, // Hardcoded for now
                      );
                      Navigator.pop(context, newSegment);
                    }
                  },
                  child: const Text('Create Segment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}
