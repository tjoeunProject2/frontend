class Favorite {
  final int favoriteId;
  final int flowerId;
  final String flowerName;
  final List<String> floriography;
  final String imageUrl;
  final DateTime createdAt;

  Favorite({
    required this.favoriteId,
    required this.flowerId,
    required this.flowerName,
    required this.floriography,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoriteId: json['favoriteId'] as int,
      flowerId: json['flowerId'] as int,
      flowerName: json['flowerName'] as String,
      floriography: (json['floriography'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
      'flowerId': flowerId,
      'flowerName': flowerName,
      'floriography': floriography,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
