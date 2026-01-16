import './segment.dart';

class Plan {
  final int id;
  final int tripId;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Segment>? segments;

  Plan({
    required this.id,
    required this.tripId,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.segments,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as int,
      tripId: json['tripId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      segments: json['segments'] != null 
          ? (json['segments'] as List).map((e) => Segment.fromJson(e as Map<String, dynamic>)).toList() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'name': name,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'segments': segments?.map((e) => e.toJson()).toList(),
    };
  }
}
