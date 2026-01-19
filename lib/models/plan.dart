import 'package:trip_planner/utils/logger.dart';
import 'package:trip_planner/utils/utils.dart';
import './segment.dart';

final log = Logger("models/Plan");

T? tc<T>(Map<String, dynamic> json, String key) => tryCatch(json, key, log);

class Plan {
  final int id;
  final int tripId;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Segment>? segments;

  Plan({
    required this.id,
    required this.tripId,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.segments,
  });

  Plan copyWith({
    int? id,
    int? tripId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Segment>? segments,
  }) {
    return Plan(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      segments: segments ?? this.segments,
    );
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic dateValue) {
      try {
      // Handle timestamp dates (milliseconds since epoch)
        if (dateValue == null) return null;
        if (dateValue is int) {
          // Timestamp in milliseconds
          return DateTime.fromMillisecondsSinceEpoch(dateValue);
        } else if (dateValue is String) {
          // ISO date string
          return DateTime.tryParse(dateValue);
        } else {
          return null;
        }
      } catch (e) {
        log.e('Error parsing plan date', e);
        rethrow;
      }
    }
    try {
      return Plan(
        id: tc(json, 'id') as int,
        tripId: tc(json, 'tripId') as int,
        name: tc(json, 'name') as String,
        description: tc(json, 'description') as String?,
        startDate: parseDate(tc(json, 'startDate')),
        endDate: parseDate(tc(json, 'endDate')),
        createdAt: tc(json, 'createdAt') != null
            ? (tc(json, 'createdAt') is int
            ? DateTime.fromMillisecondsSinceEpoch(tc(json, 'createdAt'))
            : DateTime.tryParse(tc(json, 'createdAt') as String))
            : null,
        updatedAt: tc(json, 'updatedAt') != null
            ? (tc(json, 'updatedAt') is int
            ? DateTime.fromMillisecondsSinceEpoch(tc(json, 'updatedAt'))
            : DateTime.tryParse(tc(json, 'updatedAt') as String))
            : null,
        segments: (tc(json, 'segments') != null && tc(json, 'segments') is List)
            ? (tc(json, 'segments') as List)
            .map((e) {
              try {
                return Segment.fromJson(e as Map<String, dynamic>);
              } catch (e) {
                log.e('Error parsing segment for plan: ${tc(json, 'id')}', e);
                rethrow;
              }
        })
            .toList()
            : null,
      );
    } catch (e) {
      log.e('Error parsing plan', e);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'name': name,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'segments': segments?.map((e) => e.toJson()).toList(),
    };
  }
}
