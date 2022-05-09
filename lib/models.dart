import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'api/models.dart';

class WatchedEpisodes extends ChangeNotifier {
  static const key = 'watchedEpisodes';
  final Preference<List<String>> preference;

  WatchedEpisodes(StreamingSharedPreferences prefs)
      : preference = prefs.getStringList(WatchedEpisodes.key, defaultValue: []);

  UnmodifiableListView<String> get episodeUrls =>
      UnmodifiableListView(preference.getValue());

  bool isPresent(String url) => preference.getValue().contains(url);

  void add(String url) {
    if (!isPresent(url)) {
      final urls = preference.getValue();
      urls.add(url);
      preference.setValue(urls);
      notifyListeners();
    }
  }

  void remove(String url) {
    if (isPresent(url)) {
      final urls = preference.getValue();
      urls.remove(url);
      preference.setValue(urls);
      notifyListeners();
    }
  }
}

class FavoriteShows extends ChangeNotifier {
  static const String key = 'favoriteShows';
  final Preference<String> preference;

  FavoriteShows(StreamingSharedPreferences prefs)
      : preference = prefs.getString(FavoriteShows.key, defaultValue: "[]");

  List<Map<String, String>> get() {
    final favoriteShowsStr = preference.getValue();
    var favoriteShowsDyn = <dynamic>[];
    favoriteShowsDyn = jsonDecode(favoriteShowsStr);
    final favoriteShows =
        favoriteShowsDyn.map((e) => Map<String, String>.from(e)).toList();
    return favoriteShows;
  }

  void set(List<Map<String, String>> favorites) {
    preference.setValue(json.encode(favorites));
    notifyListeners();
  }

  bool isPresent(String url) {
    final favoriteShowsStr = preference.getValue();
    List<dynamic> favoriteShows = jsonDecode(favoriteShowsStr);
    for (final dynShow in favoriteShows) {
      Map<String, String> show = Map<String, String>.from(dynShow);
      if (Show.fromMap(show).url == url) {
        return true;
      }
    }
    return false;
  }

  void toggle(Show details) {
    final present = isPresent(details.url);
    if (!present) {
      add(details);
    } else {
      remove(details);
    }
  }

  add(Show details) {
    final present = isPresent(details.url);
    if (!present) {
      final favoriteShows = get();
      favoriteShows.add(details.toMap());
      set(favoriteShows);
    }
  }

  remove(Show details) {
    final present = isPresent(details.url);
    if (present) {
      final favoriteShows = get();
      favoriteShows.removeWhere((show) => show['url'] == details.url);
      set(favoriteShows);
    }
  }
}
