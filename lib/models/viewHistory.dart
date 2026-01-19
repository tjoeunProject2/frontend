class ViewHistory {
  final int viewId;
  final int flowerId;
  final String flowerName;
  final String imageUrl;
  final DateTime createdAt;

  ViewHistory({
    required this.viewId,
    required this.flowerId,
    required this.flowerName,
    required this.imageUrl,
    required this.createdAt,
  });

  factory ViewHistory.fromJson(Map<String, dynamic> json) {
    return ViewHistory(
      viewId: json['viewId'] as int,
      flowerId: json['flowerId'] as int,
      flowerName: json['flowerName'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewId': viewId,
      'flowerId': flowerId,
      'flowerName': flowerName,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
