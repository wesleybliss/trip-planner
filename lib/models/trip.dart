import './plan.dart';

class Trip {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final String? coverImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? segmentCount; // Present if `withCounts=true`
  final List<Plan>? plans; // Present if `withDetails=true`

  Trip({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.coverImageUrl,
    this.createdAt,
    this.updatedAt,
    this.startDate,
    this.endDate,
    this.segmentCount,
    this.plans,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      segmentCount: json['segmentCount'] as int?,
      plans: json['plans'] != null 
          ? (json['plans'] as List).map((e) => Plan.fromJson(e as Map<String, dynamic>)).toList() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'segmentCount': segmentCount,
      'plans': plans?.map((e) => e.toJson()).toList(),
    };
  }
}
