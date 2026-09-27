# Code Execution Flow

This document explains the step-by-step execution flow of the Flutter application, from the moment it starts until the UI is rendered on the screen.

## 1. Application Entry Point (`lib/main.dart`)
When the app launches, the Dart runtime looks for the `main()` function, which is the starting point of any Flutter application.
```dart
void main() {
  runApp(const CountryApp());
}
```
- `runApp()` inflates the given widget and attaches it to the screen.
- It instantiates the `CountryApp` widget, which is a stateless widget returning a `MaterialApp`.
- `MaterialApp` configures the app's theme, title, and most importantly, sets the initial route via the `home` property to `NavigationPage()`.

## 2. Setting Up Navigation (`lib/widget/navigation.dart`)
The `NavigationPage` widget takes over as the root of the visible screen. 
- It is a `StatefulWidget` because it needs to maintain the state of the currently selected tab (`_currentIndex`).
- The `build` method returns a `Scaffold` with a `BottomNavigationBar` containing two items: "Home" and "Profile".
- By default, `_currentIndex` is `0`, so it displays the first item in the `pages` list, which is `HomePage()`.

## 3. Rendering the Home Page & Fetching Data (`lib/screens/home.dart`)
When `HomePage` is initialized, its state object `_HomePageState` is created.

### Initialization & API Request
- The `initState()` method is called once when the widget is inserted into the tree.
- It calls `fetchCountries()`, which performs an asynchronous HTTP GET request to `https://www.apicountries.com/countries`.
- The returned data is a JSON array. It is decoded using `jsonDecode()` and mapped into a list of `Country` objects using the `Country.fromJson()` factory constructor.

### Building the UI with FutureBuilder
- The `build` method uses a `FutureBuilder<List<Country>>` bound to the future created in `initState`.
- **Loading State:** While the HTTP request is pending (`snapshot.connectionState == ConnectionState.waiting`), the screen shows a loading spinner (`CircularProgressIndicator`).
- **Error State:** If the request fails, it displays an error message.
- **Success State:** Once the data is successfully fetched and parsed, the builder rebuilds and returns a `ListView.builder`.
- The `ListView.builder` lazily renders a list of `Card` widgets containing `ListTile`s. Each tile displays the country's flag (from network), name, and region.

## 4. Navigating to the Detail Page (`lib/screens/detail.dart`)
When a user taps on a specific country's `ListTile` in the `HomePage`:
- The `onTap` callback triggers a navigation event using `Navigator.push`.
- It passes the selected `Country` object to the `DetailPage` constructor.
- `DetailPage` builds a new screen with a `Scaffold` and an `AppBar` showing the country's name.
- The body is a `SingleChildScrollView` containing a `Column` that neatly displays all the properties of the passed `Country` object (flag, name, capital, population, languages, and currencies).

## 5. Navigating to the Profile Page (`lib/screens/profile.dart`)
If the user taps the "Profile" tab on the `BottomNavigationBar` in the `NavigationPage`:
- `_currentIndex` updates to `1`, triggering a state change (`setState()`).
- The `NavigationPage` rebuilds and switches the body to display `ProfilePage()`.
- `ProfilePage` uses a `Stack` to layer a background image and a centralized `Column` containing a profile avatar (from GitHub) and static text displaying the developer's name and NIM.
