class PlaceSuggestion {
  final String name;
  final String country;
  final double lat;
  final double lon;

  PlaceSuggestion({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    final props = json['properties'] ?? {};
    final coords = json['geometry']?['coordinates'] ?? [0, 0];

    // Photon may store city name in different fields
    final cityName =
        props['city'] ??
            props['town'] ??
            props['village'] ??
            props['name'] ??
            '';

    final countryName = props['country'] ?? '';

    return PlaceSuggestion(
      name: cityName,
      country: countryName,
      lat: (coords[1] as num).toDouble(),
      lon: (coords[0] as num).toDouble(),
    );
  }
}
