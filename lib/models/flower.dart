class Flower {
  final String id;
  final String name;
  final String koreanName;
  final String season; // 봄, 여름, 가을, 겨울
  final String occasion; // 졸업식, 기념일, 결혼식 등
  final String tag; // 클래식, 큐레이션, 로맨틱 등
  final String imageUrl;
  final String description;
  final bool isLiked;

  Flower({
    required this.id,
    required this.name,
    required this.koreanName,
    required this.season,
    required this.occasion,
    required this.tag,
    required this.imageUrl,
    required this.description,
    this.isLiked = false,
  });

  factory Flower.fromJson(Map<String, dynamic> json) {
    return Flower(
      id: json['id'] as String,
      name: json['name'] as String,
      koreanName: json['koreanName'] as String,
      season: json['season'] as String,
      occasion: json['occasion'] as String,
      tag: json['tag'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'koreanName': koreanName,
      'season': season,
      'occasion': occasion,
      'tag': tag,
      'imageUrl': imageUrl,
      'description': description,
      'isLiked': isLiked,
    };
  }

  Flower copyWith({
    String? id,
    String? name,
    String? koreanName,
    String? season,
    String? occasion,
    String? tag,
    String? imageUrl,
    String? description,
    bool? isLiked,
  }) {
    return Flower(
      id: id ?? this.id,
      name: name ?? this.name,
      koreanName: koreanName ?? this.koreanName,
      season: season ?? this.season,
      occasion: occasion ?? this.occasion,
      tag: tag ?? this.tag,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  String toString() {
    return 'Flower(id: $id, name: $name, koreanName: $koreanName, season: $season, occasion: $occasion, tag: $tag, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Flower &&
        other.id == id &&
        other.name == name &&
        other.koreanName == koreanName &&
        other.season == season &&
        other.occasion == occasion &&
        other.tag == tag &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.isLiked == isLiked;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      koreanName,
      season,
      occasion,
      tag,
      imageUrl,
      description,
      isLiked,
    );
  }
}
