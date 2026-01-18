import 'package:flutter/material.dart';
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
  late Future<Plan> _planFuture;

  @override
  void initState() {
    super.initState();
    _planFuture = _apiService.getPlan(widget.plan.id, withSegments: true);
  }

  int _calculateSchengenDays(Plan plan) {
    num totalDays = 0;
    for (var segment in plan.segments ?? []) {
      if (segment.place.isShengenRegion == true) {
        totalDays += segment.endDate.difference(segment.startDate).inDays;
      }
    }
    return totalDays.toInt();
  }

  void _editPlan(Plan plan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPlanScreen(plan: plan)),
    );
    if (result == true) {
      setState(() {
        _planFuture = _apiService.getPlan(widget.plan.id, withSegments: true);
      });
    }
  }

  void _deletePlan(int planId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan?'),
        content: const Text(
          'Are you sure you want to delete this plan? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _apiService.deletePlan(widget.plan.tripId, planId);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _addSegment(int tripId, int planId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateSegmentScreen(tripId: tripId, planId: planId),
      ),
    );
    if (result == true) {
      setState(() {
        _planFuture = _apiService.getPlan(planId, withSegments: true);
      });
    }
  }

  void _editSegment(Segment segment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSegmentScreen(segment: segment),
      ),
    );
    if (result == true) {
      setState(() {
        _planFuture = _apiService.getPlan(widget.plan.id, withSegments: true);
      });
    }
  }

  void _deleteSegment(Segment segment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Segment?'),
        content: const Text(
          'Are you sure you want to delete this segment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteSegment(segment);
        setState(() {
          _planFuture = _apiService.getPlan(widget.plan.id, withSegments: true);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete segment: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Plan>(
      future: _planFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading plan: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Plan not found.')),
          );
        } else {
          final plan = snapshot.data!;
          final schengenDays = _calculateSchengenDays(plan);

          return Scaffold(
            appBar: AppBar(
              title: Text(plan.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editPlan(plan),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deletePlan(plan.id),
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      plan.description ?? 'No description provided.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SchengenDaysCard(schengenDays: schengenDays),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Segments',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                _buildSegmentsList(plan),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _addSegment(plan.tripId, plan.id),
              icon: const Icon(Icons.add),
              label: const Text('Add Segment'),
            ),
          );
        }
      },
    );
  }

  Widget _buildSegmentsList(Plan plan) {
    final segments = plan.segments;
    if (segments == null || segments.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: [
                const Icon(
                  Icons.luggage_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No segments yet!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your first travel segment to this plan.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final segment = segments[index];
        final duration = segment.endDate.difference(segment.startDate).inDays;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
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
      }, childCount: segments.length),
    );
  }
}

class SchengenDaysCard extends StatelessWidget {
  final int schengenDays;

  const SchengenDaysCard({super.key, required this.schengenDays});

  @override
  Widget build(BuildContext context) {
    final progress = schengenDays / 90.0;
    final remainingDays = 90 - schengenDays;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schengen Zone Stay',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                  '$schengenDays / 90 Days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'You have $remainingDays days remaining in the Schengen Area.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
