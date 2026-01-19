import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/widgets/segments_list.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import '../models/plan.dart';
import '../models/segment.dart';
import '../services/api_service.dart';
import '../services/navigation_service.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  final int planId;
  final int? tripId;
  final Plan? plan; // For backward compatibility

  const PlanDetailScreen({super.key, required this.planId, this.tripId, this.plan});

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Plan> _planFuture;

  @override
  void initState() {
    super.initState();
    if (widget.tripId == null) {
      _planFuture = _apiService.getPlan(widget.planId);
    }
  }

  int _calculateSchengenDays(Plan plan) {
    num totalDays = 0;
    for (var segment in plan.segments ?? []) {
      if (segment.isShengenRegion == true) {
        totalDays += segment.endDate.difference(segment.startDate).inDays;
      }
    }
    return totalDays.toInt();
  }

  void _editPlan(BuildContext context, int planId) async {
    int? tid = widget.tripId;
    if (tid == null) {
      final plan = await _planFuture;
      tid = plan.tripId;
    }
    
    final result = await NavigationService().navigateToEditPlan(context, tid, planId);
    if (result == true) {
      if (widget.tripId != null) {
        ref.read(tripDetailsProvider(widget.tripId!).notifier).refresh();
      } else {
        setState(() {
          _planFuture = _apiService.getPlan(widget.planId);
        });
      }
    }
  }

  void _deletePlan(int planId, int tripId) async {
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
      await _apiService.deletePlan(tripId, planId);
      if (widget.tripId != null) {
        ref.read(tripDetailsProvider(widget.tripId!).notifier).refresh();
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _addSegment(BuildContext context, int planId) async {
    final result = await NavigationService().navigateToCreateSegment(context, planId);
    if (result == true) {
      if (widget.tripId != null) {
        ref.read(tripDetailsProvider(widget.tripId!).notifier).refresh();
      } else {
        setState(() {
          _planFuture = _apiService.getPlan(widget.planId);
        });
      }
    }
  }

  void _editSegment(BuildContext context, int segmentId) async {
    final result = await NavigationService().navigateToEditSegment(context, segmentId);
    if (result == true) {
      if (widget.tripId != null) {
        ref.read(tripDetailsProvider(widget.tripId!).notifier).refresh();
      } else {
        setState(() {
          _planFuture = _apiService.getPlan(widget.planId);
        });
      }
    }
  }

  void _deleteSegment(Segment segment, int tripId) async {
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
        if (widget.tripId != null) {
          ref.read(tripDetailsProvider(widget.tripId!).notifier).refresh();
        } else {
          setState(() {
            _planFuture = _apiService.getPlan(widget.planId);
          });
        }
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
    if (widget.tripId != null) {
      final tripAsync = ref.watch(tripDetailsProvider(widget.tripId!));
      return tripAsync.when(
        loading: () => const Scaffold(
          appBar: Toolbar(title: 'Plan Details'),
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          appBar: const Toolbar(title: 'Plan Details'),
          body: Center(child: Text('Error: $error')),
        ),
        data: (trip) {
          final plan = trip?.plans?.where((p) => p.id == widget.planId).firstOrNull;
          if (plan == null) {
            return const Scaffold(
              appBar: Toolbar(title: 'Plan Details'),
              body: Center(child: Text('Plan not found.')),
            );
          }
          return _buildScaffold(plan, trip!.id);
        },
      );
    }

    return FutureBuilder<Plan>(
      future: _planFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            appBar: Toolbar(title: 'Plan Details'),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: const Toolbar(title: 'Plan Details'),
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
          return const Scaffold(
            appBar: Toolbar(title: 'Plan Details'),
            body: Center(child: Text('Plan not found.')),
          );
        } else {
          final plan = snapshot.data!;
          return _buildScaffold(plan, plan.tripId);
        }
      },
    );
  }

  Widget _buildScaffold(Plan plan, int tripId) {
    final schengenDays = _calculateSchengenDays(plan);

    return Scaffold(
      appBar: Toolbar(
        title: plan.name,
        allowBackNavigation: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editPlan(context, plan.id),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deletePlan(plan.id, tripId),
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
          SegmentsList(tripId: tripId, segments: plan.segments, editSegment: _editSegment, deleteSegment: _deleteSegment),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSegment(context, plan.id),
        icon: const Icon(Icons.add),
        label: const Text('Add Segment'),
      ),
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
