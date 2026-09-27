import 'package:flutter/foundation.dart';

import '../models/country.dart';

class CountryCollections extends ChangeNotifier {
  CountryCollections._();

  static final CountryCollections instance = CountryCollections._();

  final List<Country> _favorites = [];
  final List<Country> _history = [];

  List<Country> get favorites => List.unmodifiable(_favorites);
  List<Country> get history => List.unmodifiable(_history);

  bool isFavorite(Country country) =>
      _favorites.any((item) => item.name == country.name);

  void toggleFavorite(Country country) {
    if (isFavorite(country)) {
      _favorites.removeWhere((item) => item.name == country.name);
    } else {
      _favorites.insert(0, country);
    }
    notifyListeners();
  }

  void removeFavorite(Country country) {
    _favorites.removeWhere((item) => item.name == country.name);
    notifyListeners();
  }

  void addToHistory(Country country) {
    _history.removeWhere((item) => item.name == country.name);
    _history.insert(0, country);
    notifyListeners();
  }

  void removeFromHistory(Country country) {
    _history.removeWhere((item) => item.name == country.name);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
