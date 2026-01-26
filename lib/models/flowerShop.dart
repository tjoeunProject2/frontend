class FlowerShop {
  final String id; // 고유 ID (좋아요 관리용)
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int distance;
  final String phone;
  final String placeUrl;
  final bool isLiked; // 좋아요 상태

  FlowerShop({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.phone,
    required this.placeUrl,
    this.isLiked = false,
  });

  factory FlowerShop.fromJson(Map<String, dynamic> json) {
    String firstNonEmptyString(List<dynamic> values) {
      for (final value in values) {
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
      return '';
    }

    double parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    final distanceValue = json['distance'];
    final distance = distanceValue is num
        ? distanceValue.round()
        : int.tryParse(distanceValue?.toString() ?? '') ?? 0;

    final name = json['name'] as String? ??
        json['placeName'] as String? ??
        json['place_name'] as String? ??
        '';
    final idValue = json['id'] as String? ??
        json['placeId'] as String? ??
        json['place_id'] as String? ??
        name;
    final lat = parseDouble(json['lat'] ?? json['latitude'] ?? json['y']);
    final lng = parseDouble(json['lng'] ?? json['longitude'] ?? json['x']);
    final id = idValue.trim().isEmpty
        ? '${name}_${lat}_${lng}'
        : idValue;

    return FlowerShop(
      id: id,
      name: name,
      address: firstNonEmptyString([
        json['address'],
        json['roadAddress'],
        json['addressName'],
        json['address_name'],
        json['road_address'],
        json['road_address_name'],
      ]),
      lat: lat,
      lng: lng,
      distance: distance,
      phone: firstNonEmptyString([
        json['phone'],
        json['phoneNumber'],
        json['tel'],
        json['phone_number'],
      ]),
      placeUrl: firstNonEmptyString([
        json['placeUrl'],
        json['place_url'],
      ]),
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'distance': distance,
      'phone': phone,
      'placeUrl': placeUrl,
      'isLiked': isLiked,
    };
  }

  FlowerShop copyWith({
    String? id,
    String? name,
    String? address,
    double? lat,
    double? lng,
    int? distance,
    String? phone,
    String? placeUrl,
    bool? isLiked,
  }) {
    return FlowerShop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distance: distance ?? this.distance,
      phone: phone ?? this.phone,
      placeUrl: placeUrl ?? this.placeUrl,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  String toString() {
    return 'FlowerShop(id: $id, name: $name, address: $address, lat: $lat, lng: $lng, distance: $distance, phone: $phone, placeUrl: $placeUrl, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowerShop &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.lat == lat &&
        other.lng == lng &&
        other.distance == distance &&
        other.phone == phone &&
        other.placeUrl == placeUrl &&
        other.isLiked == isLiked;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    address.hashCode ^
    lat.hashCode ^
    lng.hashCode ^
    distance.hashCode ^
    phone.hashCode ^
    placeUrl.hashCode;
  }

  // 거리를 사람이 읽기 쉬운 형태로 반환
  String get formattedDistance {
    if (distance < 1000) {
      return '${distance}m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
  }
}
