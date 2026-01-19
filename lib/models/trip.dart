import 'package:trip_planner/utils/logger.dart';
import 'package:trip_planner/utils/utils.dart';

import './plan.dart';

final log = Logger("models/Trip");

T? tc<T>(Map<String, dynamic> json, String key) => tryCatch(json, key, log);

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
  final int? segmentCount;
  final List<Plan>? plans;

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

  Trip copyWith({
    int? id,
    int? userId,
    String? name,
    String? description,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
    int? segmentCount,
    List<Plan>? plans,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      segmentCount: segmentCount ?? this.segmentCount,
      plans: plans ?? this.plans,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: tc(json, 'id') as int,
      userId: tc(json, 'userId') as int,
      name: tc(json, 'name') as String,
      description: tc(json, 'description') as String?,
      coverImageUrl: tc(json, 'coverImageUrl') as String?,
      createdAt: tc(json, 'createdAt') != null
          ? DateTime.tryParse(tc(json, 'createdAt'))
          : null,
      updatedAt: tc(json, 'updatedAt') != null
          ? DateTime.tryParse(tc(json, 'updatedAt'))
          : null,
      startDate: tc(json, 'startDate') != null
          ? DateTime.tryParse(tc(json, 'startDate'))
          : null,
      endDate: tc(json, 'endDate') != null
          ? DateTime.tryParse(tc(json, 'endDate'))
          : null,
      segmentCount: tc(json, 'segmentCount') as int?,
      plans: json['plans'] != null
          ? (json['plans'] as List)
                .map((e) {
                  try {
                    return Plan.fromJson(e as Map<String, dynamic>);
                  } catch (e) {
                    log.e('Error parsing plan for trip: ${json['id']}', e);
                    rethrow;
                  }
      })
                .toList()
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
