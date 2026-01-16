class Place {
  final int id;
  final String name;
  final String country;
  final bool isShengenRegion;

  Place({
    required this.id,
    required this.name,
    required this.country,
    required this.isShengenRegion,
  });

  Place copyWith({
    int? id,
    String? name,
    String? country,
    bool? isShengenRegion,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      isShengenRegion: isShengenRegion ?? this.isShengenRegion,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String,
      isShengenRegion: json['isShengenRegion'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'isShengenRegion': isShengenRegion,
    };
  }
}
