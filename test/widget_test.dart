// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, usethe WidgetTester
// utility in the flutter_test package. For example, you cansend tap and scroll
// gestures. You can also use WidgetTester to find childwidgets in the widget
// tree, read text, and verify that the values of widgetproperties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:mod3_kel12/data/country_collections.dart';
import 'package:mod3_kel12/main.dart';
import 'package:mod3_kel12/models/country.dart';

void main() {
  test('country collections support favorite and hard history deletion', () {
    final collections = CountryCollections.instance;
    const country = Country(
      name: 'Brazil',
      region: 'Americas',
      subregion: 'South America',
      population: 200000000,
    );

    collections.toggleFavorite(country);
    collections.addToHistory(country);
    expect(collections.isFavorite(country), isTrue);
    expect(collections.history, contains(country));
    expect(country.continent, 'Amerika Selatan');

    collections.removeFavorite(country);
    collections.clearHistory();
    expect(collections.isFavorite(country), isFalse);
    expect(collections.history, isEmpty);
  });

  testWidgets('Country app displays its main navigation', (
    WidgetTester tester,
  ) async {
    CountryCollections.instance.addToHistory(
      const Country(
        name: 'Brazil',
        region: 'Americas',
        subregion: 'South America',
        population: 200000000,
      ),
    );
    await tester.pumpWidget(const CountryApp());
    expect(find.text('Countries'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    await tester.tap(find.text('Riwayat'));
    await tester.pump();
    expect(find.text('Brazil'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pump();
    expect(find.text('Aufan Damays Marsuki'), findsOneWidget);
    expect(find.text('NIM: 21120124140163'), findsOneWidget);

    CountryCollections.instance.clearHistory();
    await tester.tap(find.text('Riwayat'));
    await tester.pump();
    expect(
      find.text('Buka Home, lalu ketuk negara untuk mulai mencatat.'),
      findsOneWidget,
    );
  });
}
