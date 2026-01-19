import 'package:trip_planner/utils/logger.dart';
import 'package:trip_planner/utils/utils.dart';

final log = Logger("models/Segment");

T? tc<T>(Map<String, dynamic> json, String key) => tryCatch(json, key, log);

class Segment {
  final int id;
  final int tripId;
  final int planId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final double? coordsLat;
  final double? coordsLng;
  final String color;
  final bool flightBooked;
  final bool stayBooked;
  final bool isShengenRegion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Segment({
    required this.id,
    required this.tripId,
    required this.planId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.coordsLat,
    this.coordsLng,
    required this.color,
    required this.flightBooked,
    required this.stayBooked,
    required this.isShengenRegion,
    this.createdAt,
    this.updatedAt,
  });

  Segment copyWith({
    int? id,
    int? tripId,
    int? planId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? coordsLat,
    double? coordsLng,
    String? color,
    bool? flightBooked,
    bool? stayBooked,
    bool? isShengenRegion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Segment(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      planId: planId ?? this.planId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coordsLat: coordsLat ?? this.coordsLat,
      coordsLng: coordsLng ?? this.coordsLng,
      color: color ?? this.color,
      flightBooked: flightBooked ?? this.flightBooked,
      stayBooked: stayBooked ?? this.stayBooked,
      isShengenRegion: isShengenRegion ?? this.isShengenRegion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Segment.fromJson(Map<String, dynamic> json) {
    // Handle timestamp dates (milliseconds since epoch)
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) {
        return null;
      } else if (dateValue is int) {
        // Timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      } else if (dateValue is String) {
        // ISO date string
        return DateTime.parse(dateValue);
      } else {
        throw Exception('Invalid date format: $dateValue');
      }
    }

    return Segment(
      id: tc(json, 'id') as int,
      tripId: tc(json, 'tripId') as int,
      planId: tc(json, 'planId') as int,
      name: tc(json, 'name') as String,
      description: tc(json, 'description') as String?,
      startDate: parseDate(tc(json, 'startDate'))!,
      endDate: parseDate(tc(json, 'endDate'))!,
      coordsLat: (tc(json, 'coordsLat') as num?)?.toDouble(),
      coordsLng: (tc(json, 'coordsLng') as num?)?.toDouble(),
      color: tc(json, 'color') as String,
      flightBooked: tc(json, 'flightBooked') as bool? ?? false,
      stayBooked: tc(json, 'stayBooked') as bool? ?? false,
      isShengenRegion: tc(json, 'isShengenRegion') as bool? ?? false,
      createdAt: parseDate(tc(json, 'createdAt')),
      updatedAt: parseDate(tc(json, 'updatedAt')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'planId': planId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'coordsLat': coordsLat,
      'coordsLng': coordsLng,
      'color': color,
      'flightBooked': flightBooked,
      'stayBooked': stayBooked,
      'isShengenRegion': isShengenRegion,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
