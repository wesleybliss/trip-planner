import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import '../models/segment.dart';
import '../services/api_service.dart';
import '../models/place.dart';

class EditSegmentScreen extends StatefulWidget {
  final int segmentId;
  final Segment? segment; // For backward compatibility

  const EditSegmentScreen({super.key, required this.segmentId, this.segment});

  @override
  State<EditSegmentScreen> createState() => _EditSegmentScreenState();
}

class _EditSegmentScreenState extends State<EditSegmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late Future<Segment> _segmentFuture;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _endDate;
  Place? _selectedPlace;
  late Future<List<Place>> _placesFuture;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _segmentFuture = _apiService.getSegment(widget.segmentId);
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

  void _updateSegment() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null &&
        _selectedPlace != null) {
      // First get the current segment data
      final currentSegment = await _segmentFuture;
      final updatedSegment = currentSegment.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        coordsLat: currentSegment.coordsLat,
        coordsLng: currentSegment.coordsLng,
        color: currentSegment.color, // Keep existing color
        isShengenRegion: currentSegment.isShengenRegion,
      );
      await _apiService.updateSegment(updatedSegment);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Segment>(
      future: _segmentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            appBar: Toolbar(title: 'Edit Segment', allowBackNavigation: true),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: const Toolbar(title: 'Edit Segment', allowBackNavigation: true),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            appBar: Toolbar(title: 'Edit Segment', allowBackNavigation: true),
            body: Center(child: Text('No segment data available')),
          );
        } else {
          final segment = snapshot.data!;
          
          if (!_controllersInitialized) {
            _nameController.text = segment.name;
            _descriptionController.text = segment.description ?? '';
            _startDate = segment.startDate;
            _endDate = segment.endDate;
            _controllersInitialized = true;
          }

          return Scaffold(
            appBar: const Toolbar(title: 'Edit Segment', allowBackNavigation: true),
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
                      builder: (context, placesSnapshot) {
                        if (placesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (placesSnapshot.hasError) {
                          return Text('Error: ${placesSnapshot.error}');
                        } else if (!placesSnapshot.hasData ||
                            placesSnapshot.data!.isEmpty) {
                          return const Text('No places available');
                        } else {
                          final places = placesSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Place',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              DropdownButtonFormField<Place>(
                                initialValue: _selectedPlace,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: places.map((Place place) {
                                  return DropdownMenuItem<Place>(
                                    value: place,
                                    child: Text(place.name),
                                  );
                                }).toList(),
                                onChanged: (Place? newValue) {
                                  setState(() {
                                    _selectedPlace = newValue;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a place'
                                    : null,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateSegment,
                        child: const Text('Update Segment'),
                      ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
