class Place {
  final int? id;
  final String name;
  final String? type; // Added to match the API service
  final String? coverImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Place({
    this.id,
    required this.name,
    this.type,
    this.coverImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  Place copyWith({
    int? id,
    String? name,
    String? type,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int?,
      name: json['name'] as String,
      type: json['type'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
