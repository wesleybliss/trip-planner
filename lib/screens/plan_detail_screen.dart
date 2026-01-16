import 'package:flutter/material.dart';
import '../models/plan.dart';

class PlanDetailScreen extends StatelessWidget {
  final Plan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
      ),
      body: ListView.builder(
        itemCount: plan.segments?.length ?? 0,
        itemBuilder: (context, index) {
          final segment = plan.segments![index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(segment.name),
              subtitle: Text('${segment.startDate} - ${segment.endDate}'),
              // You can add more segment details here
            ),
          );
        },
      ),
    );
  }
}
