import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/segment.dart';
import '../services/api_service.dart';
import '../models/place.dart';

class CreateSegmentScreen extends StatefulWidget {
  final int tripId;
  final int planId;

  const CreateSegmentScreen({
    super.key,
    required this.tripId,
    required this.planId,
  });

  @override
  State<CreateSegmentScreen> createState() => _CreateSegmentScreenState();
}

class _CreateSegmentScreenState extends State<CreateSegmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  Place? _selectedPlace;
  late Future<List<Place>> _placesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _placesFuture = _apiService.getPlaces();
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());
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

  void _createSegment() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null &&
        _selectedPlace != null) {
      final newSegment = Segment(
        id: 0,
        tripId: widget.tripId,
        planId: widget.planId,
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        place: _selectedPlace!,
        flightBooked: false,
        stayBooked: false,
        isShengenRegion: _selectedPlace!.isShengenRegion,
      );
      await _apiService.createSegment(newSegment);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Segment')),
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                        child: Text(
                          _startDate != null
                              ? DateFormat.yMMMd().format(_startDate!)
                              : 'Select Date',
                        ),
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
                        child: Text(
                          _endDate != null
                              ? DateFormat.yMMMd().format(_endDate!)
                              : 'Select Date',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<List<Place>>(
                future: _placesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<Place>(
                      decoration: const InputDecoration(
                        labelText: 'Place',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedPlace,
                      items: snapshot.data!.map((place) {
                        return DropdownMenuItem<Place>(
                          value: place,
                          child: Text(place.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPlace = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a place';
                        }
                        return null;
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _createSegment,
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
    _descriptionController.dispose();
    super.dispose();
  }
}
