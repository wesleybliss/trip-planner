import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6.0),
              if (trip.description != null)
                Text(
                  trip.description!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8.0),
              if (trip.startDate != null && trip.endDate != null)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      '${DateFormat.yMMMd().format(trip.startDate!)}\n${DateFormat.yMMMd().format(trip.endDate!)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              else
                const Text(
                  'No date range',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
