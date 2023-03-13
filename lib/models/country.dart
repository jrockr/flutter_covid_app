class Country {
  final String country;
  final String slug;
  final String iso2;

  Country({required this.country, required this.slug, required this.iso2});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      country: json['Country'] ?? "",
      slug: json['Slug'] ?? "",
      iso2: json['ISO2'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Country(Country:$country, ISO2:$iso2)';
  }
}
