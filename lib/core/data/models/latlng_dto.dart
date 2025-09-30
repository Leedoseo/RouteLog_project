class LatLngDto {
  final double lat;
  final double lng;

  const LatLngDto({required this.lat, required this.lng});

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  factory LatLngDto.fromJson(Map<String, dynamic> json) =>
      LatLngDto(lat: (json['lat'] as num).toDouble(), lng: (json['lng'] as num).toDouble());
}
