import './segment.dart';

class Plan {
  final int id;
  final int tripId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Segment>? segments; // Present if `withDetails=true`

  Plan({
    required this.id,
    required this.tripId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
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
    return Plan(
      id: json['id'] as int,
      tripId: json['tripId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      segments: json['segments'] != null
          ? (json['segments'] as List)
              .map((e) => Segment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'segments': segments?.map((e) => e.toJson()).toList(),
    };
  }
}
