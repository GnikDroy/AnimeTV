import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'api/models.dart';

class WatchedEpisode {
  String url;
  Duration timestamp;

  WatchedEpisode({
    this.url = '',
    this.timestamp = const Duration(seconds: 0),
  });

  WatchedEpisode.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        timestamp = Duration(seconds: json['timestamp']);

  Map<String, dynamic> toJson() => {
        'url': url,
        'timestamp': timestamp.inSeconds,
      };
}

class FavoriteShow {
  String url;
  String title;
  String description;
  String image;

  FavoriteShow({
    this.url = '',
    this.title = '',
    this.description = '',
    this.image = '',
  });

  FavoriteShow.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        title = json['title'],
        description = json['description'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'title': title,
        'description': description,
        'image': image,
      };
}

class WatchedEpisodes extends ChangeNotifier {
  static const key = 'watchedEpisodes';
  final Preference<String> preference;

  WatchedEpisodes(StreamingSharedPreferences prefs)
      : preference = prefs.getString(WatchedEpisodes.key, defaultValue: '[]');

  List<WatchedEpisode> get() {
    List<dynamic> json = jsonDecode(preference.getValue());
    return json
        .cast<Map<String, dynamic>>()
        .map<WatchedEpisode>(WatchedEpisode.fromJson)
        .toList();
  }

  void set(List<WatchedEpisode> episodes) {
    preference.setValue(jsonEncode(episodes));
  }

  List<String> get episodeUrls => get().map((x) => x.url).toList();

  void setTimestamp(String url, Duration duration) {
    if (!isPresent(url)) add(url);
    final episodes = get();
    for (final episode in episodes) {
      if (episode.url == url) {
        episode.timestamp = duration;
        set(episodes);
        return;
      }
    }
  }

  bool isPresent(String url) => episodeUrls.contains(url);

  void add(String url) {
    if (!isPresent(url)) {
      final episodes = get();
      episodes.add(WatchedEpisode(url: url));
      set(episodes);
      notifyListeners();
    }
  }

  void remove(String url) {
    if (isPresent(url)) {
      final episodes = get();
      episodes.removeWhere((x) => x.url == url);
      set(episodes);
      notifyListeners();
    }
  }
}

class FavoriteShows extends ChangeNotifier {
  static const String key = 'favoriteShows';
  final Preference<String> preference;

  FavoriteShows(StreamingSharedPreferences prefs)
      : preference = prefs.getString(FavoriteShows.key, defaultValue: "[]");

  List<FavoriteShow> get() {
    return jsonDecode(preference.getValue())
        .cast<Map<String, dynamic>>()
        .map<FavoriteShow>(FavoriteShow.fromJson)
        .toList();
  }

  void set(List<FavoriteShow> favorites) {
    preference.setValue(json.encode(favorites));
    notifyListeners();
  }

  bool isPresent(String url) {
    return get().fold<bool>(false, (prev, show) => prev || show.url == url);
  }

  void toggle(Show details) {
    isPresent(details.url) ? remove(details) : add(details);
  }

  void add(Show details) {
    if (!isPresent(details.url)) {
      final shows = get();
      shows.add(FavoriteShow(
        url: details.url,
        title: details.title,
        description: details.description,
        image: details.image,
      ));
      set(shows);
    }
  }

  void remove(Show details) {
    if (isPresent(details.url)) {
      final favoriteShows = get();
      favoriteShows.removeWhere((show) => show.url == details.url);
      set(favoriteShows);
    }
  }
}
