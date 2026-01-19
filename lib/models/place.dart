class Place {
  final int id;
  final String name;
  final String? coverImageUrl;

  Place({
    required this.id,
    required this.name,
    this.coverImageUrl,
  });

  Place copyWith({
    int? id,
    String? name,
    String? coverImageUrl,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      name: json['name'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverImageUrl': coverImageUrl ?? '',
    };
  }
}
