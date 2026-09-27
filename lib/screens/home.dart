import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import '../data/country_collections.dart';
import '../models/country.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  String _query = '';
  String _selectedContinent = 'Semua benua';

  static const _continents = [
    'Semua benua',
    'Afrika',
    'Amerika Utara',
    'Amerika Selatan',
    'Antarktika',
    'Asia',
    'Eropa',
    'Oseania',
  ];

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List jsonData = jsonDecode(respBody);
      return jsonData.map((j) => Country.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries')),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          }
          final filteredCountries = snapshot.data!.where((country) {
            final query = _query.trim().toLowerCase();
            final matchesSearch =
                query.isEmpty ||
                country.name.toLowerCase().contains(query) ||
                (country.capital?.toLowerCase().contains(query) ?? false);
            final matchesContinent =
                _selectedContinent == 'Semua benua' ||
                country.continent == _selectedContinent;
            return matchesSearch && matchesContinent;
          }).toList();
          filteredCountries.sort(
            (first, second) =>
                first.name.toLowerCase().compareTo(second.name.toLowerCase()),
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cari negara',
                    hintText: 'Nama negara atau ibu kota',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedContinent,
                  decoration: const InputDecoration(
                    labelText: 'Pilih benua',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.public),
                  ),
                  items: _continents
                      .map(
                        (continent) => DropdownMenuItem(
                          value: continent,
                          child: Text(continent),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedContinent = value);
                    }
                  },
                ),
              ),
              Expanded(
                child: filteredCountries.isEmpty
                    ? const Center(child: Text('Negara tidak ditemukan'))
                    : ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          return Card(
                            child: ListTile(
                              leading: country.flagsPng == null
                                  ? const Icon(Icons.flag_outlined)
                                  : Image.network(
                                      country.flagsPng!,
                                      width: 50,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) => const Icon(Icons.flag_outlined),
                                    ),
                              title: Text(country.name),
                              subtitle: Text(country.continent),
                              trailing: AnimatedBuilder(
                                animation: CountryCollections.instance,
                                builder: (context, _) {
                                  final isFavorite = CountryCollections.instance
                                      .isFavorite(country);
                                  return IconButton(
                                    tooltip: isFavorite
                                        ? 'Hapus dari favorit'
                                        : 'Tambah ke favorit',
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () => CountryCollections.instance
                                        .toggleFavorite(country),
                                  );
                                },
                              ),
                              onTap: () {
                                CountryCollections.instance.addToHistory(
                                  country,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPage(country: country),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
