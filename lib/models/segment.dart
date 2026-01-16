import 'place.dart';

class Segment {
  final int id;
  final int tripId;
  final int planId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final Place place;
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
    required this.place,
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
    Place? place,
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
      place: place ?? this.place,
      flightBooked: flightBooked ?? this.flightBooked,
      stayBooked: stayBooked ?? this.stayBooked,
      isShengenRegion: isShengenRegion ?? this.isShengenRegion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['id'] as int,
      tripId: json['tripId'] as int,
      planId: json['planId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
      flightBooked: json['flightBooked'] as bool? ?? false,
      stayBooked: json['stayBooked'] as bool? ?? false,
      isShengenRegion: json['isShengenRegion'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
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
      'place': place.toJson(),
      'flightBooked': flightBooked,
      'stayBooked': stayBooked,
      'isShengenRegion': isShengenRegion,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
