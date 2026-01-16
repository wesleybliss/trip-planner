import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/plan.dart';
import '../models/segment.dart';
import '../services/api_service.dart';
import 'edit_plan_screen.dart';
import 'create_segment_screen.dart';
import 'edit_segment_screen.dart';

class PlanDetailScreen extends StatefulWidget {
  final Plan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  final ApiService _apiService = ApiService();
  late Plan _plan;

  @override
  void initState() {
    super.initState();
    _plan = widget.plan;
  }

  void _editPlan() async {
    final updatedPlan = await Navigator.push<Plan>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlanScreen(plan: _plan),
      ),
    );
    if (updatedPlan != null) {
      await _apiService.updatePlan(updatedPlan);
      setState(() {
        _plan = updatedPlan;
      });
    }
  }

  void _deletePlan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan?'),
        content: const Text('Are you sure you want to delete this plan? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _apiService.deletePlan(_plan.tripId, _plan.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _addSegment() async {
    final newSegment = await Navigator.push<Segment>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSegmentScreen(tripId: _plan.tripId, planId: _plan.id),
      ),
    );
    if (newSegment != null) {
      final createdSegment = await _apiService.createSegment(newSegment);
      setState(() {
        _plan.segments = [..._plan.segments ?? [], createdSegment];
      });
    }
  }

  void _editSegment(Segment segment) async {
    final updatedSegment = await Navigator.push<Segment>(
      context,
      MaterialPageRoute(
        builder: (context) => EditSegmentScreen(segment: segment),
      ),
    );
    if (updatedSegment != null) {
      await _apiService.updateSegment(updatedSegment);
      setState(() {
        final index = _plan.segments!.indexWhere((s) => s.id == updatedSegment.id);
        if (index != -1) {
          _plan.segments![index] = updatedSegment;
        }
      });
    }
  }

  void _deleteSegment(Segment segment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Segment?'),
        content: const Text('Are you sure you want to delete this segment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _apiService.deleteSegment(segment);
      setState(() {
        _plan.segments!.removeWhere((s) => s.id == segment.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_plan.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editPlan();
              } else if (value == 'delete') {
                _deletePlan();
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
          _buildPlanHeader(context),
          const SizedBox(height: 16.0),
          _buildSegmentsList(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSegment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlanHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _plan.name,
            style: GoogleFonts.oswald(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            _plan.description ?? 'No description provided.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentsList(BuildContext context) {
    if (_plan.segments == null || _plan.segments!.isEmpty) {
      return const Center(
        child: Text('No segments for this plan yet.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _plan.segments!.length,
      itemBuilder: (context, index) {
        final segment = _plan.segments![index];
        final duration = segment.endDate.difference(segment.startDate).inDays;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      segment.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editSegment(segment);
                        } else if (value == 'delete') {
                          _deleteSegment(segment);
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
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16.0),
                    const SizedBox(width: 8.0),
                    Text(
                      '${DateFormat.yMMMd().format(segment.startDate)} - ${DateFormat.yMMMd().format(segment.endDate)} ($duration days)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                 Row(
                  children: [
                    const Icon(Icons.place, size: 16.0),
                    const SizedBox(width: 8.0),
                    Text(
                      segment.place.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
