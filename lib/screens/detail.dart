import 'package:flutter/material.dart';

import '../data/country_collections.dart';
import '../models/country.dart';

class DetailPage extends StatefulWidget {
  final Country country;
  const DetailPage({super.key, required this.country});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    CountryCollections.instance.addToHistory(widget.country);
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.country;
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          AnimatedBuilder(
            animation: CountryCollections.instance,
            builder: (context, _) {
              final isFavorite = CountryCollections.instance.isFavorite(
                country,
              );
              return IconButton(
                tooltip: isFavorite
                    ? 'Hapus dari favorit'
                    : 'Tambah ke favorit',
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () =>
                    CountryCollections.instance.toggleFavorite(country),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (country.flagsPng != null)
              Center(
                child: Image.network(
                  country.flagsPng!,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flag_outlined, size: 96),
                ),
              ),
            const SizedBox(height: 16),
            Text('Name: ${country.name}', style: const TextStyle(fontSize: 18)),
            Text(
              'Capital: ${country.capital ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Benua: ${country.continent}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Population: ${country.population}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Bahasa: ${country.languages?.join(', ') ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Mata uang: ${country.currencies?.join(', ') ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
