class FlowerShop {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int distance;
  final String phone;
  final String placeUrl;

  FlowerShop({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.phone,
    required this.placeUrl,
  });

  factory FlowerShop.fromJson(Map<String, dynamic> json) {
    return FlowerShop(
      name: json['name'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      distance: json['distance'] as int,
      phone: json['phone'] as String,
      placeUrl: json['placeUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'distance': distance,
      'phone': phone,
      'placeUrl': placeUrl,
    };
  }

  FlowerShop copyWith({
    String? name,
    String? address,
    double? lat,
    double? lng,
    int? distance,
    String? phone,
    String? placeUrl,
  }) {
    return FlowerShop(
      name: name ?? this.name,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distance: distance ?? this.distance,
      phone: phone ?? this.phone,
      placeUrl: placeUrl ?? this.placeUrl,
    );
  }

  @override
  String toString() {
    return 'FlowerShop(name: $name, address: $address, lat: $lat, lng: $lng, distance: $distance, phone: $phone, placeUrl: $placeUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlowerShop &&
        other.name == name &&
        other.address == address &&
        other.lat == lat &&
        other.lng == lng &&
        other.distance == distance &&
        other.phone == phone &&
        other.placeUrl == placeUrl;
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
