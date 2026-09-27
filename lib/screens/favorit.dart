import 'package:flutter/material.dart';

import '../data/country_collections.dart';
import '../models/country.dart';
import 'detail.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = CountryCollections.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: AnimatedBuilder(
        animation: collections,
        builder: (context, _) {
          final favorites = collections.favorites;
          if (favorites.isEmpty) {
            return const Center(child: Text('Belum ada negara favorit'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final country = favorites[index];
              return _FavoriteTile(
                country: country,
                onRemove: () => collections.removeFavorite(country),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.country, required this.onRemove});

  final Country country;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: country.flagsPng == null
          ? const Icon(Icons.flag_outlined)
          : Image.network(
              country.flagsPng!,
              width: 48,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.flag_outlined),
            ),
      title: Text(country.name),
      subtitle: Text('${country.continent} · ${country.region}'),
      trailing: IconButton(
        tooltip: 'Hapus dari favorit',
        icon: const Icon(Icons.favorite, color: Colors.red),
        onPressed: onRemove,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(country: country)),
        );
      },
    );
  }
}
