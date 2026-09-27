class Country {
  final String name;
  final String region;
  final String? subregion;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<String>? languages;
  final List<String>? currencies;

  const Country({
    required this.name,
    required this.region,
    required this.population,
    this.subregion,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  String get continent {
    switch (region.toLowerCase()) {
      case 'africa':
        return 'Afrika';
      case 'americas':
        return subregion?.toLowerCase().contains('south america') == true
            ? 'Amerika Selatan'
            : 'Amerika Utara';
      case 'asia':
        return 'Asia';
      case 'europe':
        return 'Eropa';
      case 'oceania':
        return 'Oseania';
      case 'antarctic':
        return 'Antarktika';
      default:
        return region.isEmpty ? 'Lainnya' : region;
    }
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    final flags = json['flags'];
    final languages = json['languages'];
    final currencies = json['currencies'];

    return Country(
      name: json['name']?.toString() ?? 'N/A',
      region: json['region']?.toString() ?? 'N/A',
      subregion: json['subregion']?.toString(),
      population: json['population'] is int ? json['population'] as int : 0,
      capital: json['capital']?.toString(),
      flagsPng: flags is Map ? flags['png']?.toString() : null,
      languages: languages is List
          ? languages
                .map((item) => item is Map ? item['name']?.toString() : null)
                .whereType<String>()
                .toList()
          : null,
      currencies: currencies is List
          ? currencies
                .map((item) => item is Map ? item['name']?.toString() : null)
                .whereType<String>()
                .toList()
          : null,
    );
  }
}
