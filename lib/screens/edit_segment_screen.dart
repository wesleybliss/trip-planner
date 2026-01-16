import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/segment.dart';
import '../services/api_service.dart';
import '../models/place.dart';

class EditSegmentScreen extends StatefulWidget {
  final Segment segment;

  const EditSegmentScreen({super.key, required this.segment});

  @override
  State<EditSegmentScreen> createState() => _EditSegmentScreenState();
}

class _EditSegmentScreenState extends State<EditSegmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _endDate;
  Place? _selectedPlace;
  late Future<List<Place>> _placesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.segment.name);
    _descriptionController = TextEditingController(text: widget.segment.description);
    _startDate = widget.segment.startDate;
    _endDate = widget.segment.endDate;
    _selectedPlace = widget.segment.place;
    _placesFuture = _apiService.getPlaces();
  }

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

  void _updateSegment() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null &&
        _selectedPlace != null) {
      final updatedSegment = widget.segment.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        place: _selectedPlace!,
        isShengenRegion: _selectedPlace!.isShengenRegion,
      );
      await _apiService.updateSegment(updatedSegment);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Segment'),
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
              FutureBuilder<List<Place>>(
                future: _placesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<Place>(
                      decoration: const InputDecoration(
                        labelText: 'Place',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedPlace,
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
