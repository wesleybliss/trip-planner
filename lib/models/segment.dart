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

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['id'] as int,
      tripId: json['tripId'] as int,
      planId: json['planId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      coordsLat: (json['coordsLat'] as num?)?.toDouble(),
      coordsLng: (json['coordsLng'] as num?)?.toDouble(),
      color: json['color'] as String,
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
