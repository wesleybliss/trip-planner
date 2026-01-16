class Place {
  final int? id;
  final String name;
  final String? coverImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Place({
    this.id,
    required this.name,
    this.coverImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int?,
      name: json['name'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
