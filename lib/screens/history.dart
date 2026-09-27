import 'package:flutter/material.dart';

import '../data/country_collections.dart';
import '../models/country.dart';
import 'detail.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _confirmClearHistory(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus semua riwayat?'),
        content: const Text('Riwayat yang dihapus tidak dapat dipulihkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus permanen'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      CountryCollections.instance.clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final collections = CountryCollections.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          AnimatedBuilder(
            animation: collections,
            builder: (context, _) => IconButton(
              tooltip: 'Hapus semua riwayat',
              onPressed: collections.history.isEmpty
                  ? null
                  : () => _confirmClearHistory(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: collections,
        builder: (context, _) {
          final history = collections.history;
          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Belum ada riwayat negara'),
                  SizedBox(height: 4),
                  Text('Buka Home, lalu ketuk negara untuk mulai mencatat.'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final country = history[index];
              return _HistoryTile(
                country: country,
                index: index,
                onDelete: () => collections.removeFromHistory(country),
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.country,
    required this.index,
    required this.onDelete,
  });

  final Country country;
  final int index;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: country.flagsPng == null
          ? CircleAvatar(child: Text('${index + 1}'))
          : Image.network(
              country.flagsPng!,
              width: 48,
              errorBuilder: (context, error, stackTrace) =>
                  CircleAvatar(child: Text('${index + 1}')),
            ),
      title: Text(country.name),
      subtitle: Text(country.continent),
      trailing: IconButton(
        tooltip: 'Hapus dari riwayat',
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
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
