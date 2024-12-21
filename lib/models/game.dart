class Game {
  final int id;
  final String name;
  final String backgroundImage;
  final double rating;
  final String released;
  final String descriptionRaw;

  Game({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.rating,
    required this.released,
    required this.descriptionRaw,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'] ?? 'Unknown Game',
      backgroundImage: json['background_image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      released: json['released'] ?? 'Unknown Release Date',
      descriptionRaw: json['description_raw'] ?? 'No description available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'background_image': backgroundImage,
      'rating': rating,
      'released': released,
      'description_raw': descriptionRaw,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'] ?? 'Unknown Game',
      backgroundImage: map['background_image'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      released: map['released'] ?? 'Unknown Release Date',
      descriptionRaw: map['description_raw'] ?? 'No description available',
    );
  }
}
