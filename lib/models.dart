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

class LastEpisode extends ChangeNotifier {
  static const key = 'lastEpisode';
  final Preference<String> preference;

  LastEpisode(StreamingSharedPreferences prefs)
      : preference = prefs.getString(LastEpisode.key, defaultValue: '');

  String get() => preference.getValue();

  Future<void> set(String url) async {
    await preference.setValue(url);
    notifyListeners();
  }
}

class WatchedEpisodes extends ChangeNotifier {
  static const key = 'watchedEpisodes';
  final Preference<String> preference;
  List<WatchedEpisode>? watchedEpisodes;

  WatchedEpisodes(StreamingSharedPreferences prefs)
      : preference = prefs.getString(WatchedEpisodes.key, defaultValue: '[]');

  List<WatchedEpisode> get() {
    if (watchedEpisodes == null) {
      List<dynamic> json = jsonDecode(preference.getValue());
      watchedEpisodes = json
          .cast<Map<String, dynamic>>()
          .map<WatchedEpisode>(WatchedEpisode.fromJson)
          .toList();
    }
    return watchedEpisodes!;
  }

  Future<void> set(List<WatchedEpisode> episodes) async {
    watchedEpisodes = episodes;
    await preference.setValue(jsonEncode(episodes));
    notifyListeners();
  }

  List<String> get episodeUrls => get().map((x) => x.url).toList();

  Future<void> setTimestamp(String url, Duration duration) async {
    if (!isPresent(url)) add(url);
    final episodes = get();
    for (final episode in episodes) {
      if (episode.url == url) {
        episode.timestamp = duration;
        await set(episodes);
      }
    }
  }

  bool isPresent(String url) => episodeUrls.contains(url);

  Future<void> add(String url) async {
    if (!isPresent(url)) {
      final episodes = get();
      episodes.add(WatchedEpisode(url: url));
      await set(episodes);
    }
  }

  Future<void> remove(String url) async {
    if (isPresent(url)) {
      final episodes = get();
      episodes.removeWhere((x) => x.url == url);
      await set(episodes);
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

  Future<void> set(List<FavoriteShow> favorites) async {
    await preference.setValue(json.encode(favorites));
    notifyListeners();
  }

  bool isPresent(String url) {
    return get().fold<bool>(false, (prev, show) => prev || show.url == url);
  }

  Future<void> toggle(Show details) async {
    isPresent(details.url) ? await remove(details) : await add(details);
  }

  Future<void> add(Show details) async {
    if (!isPresent(details.url)) {
      final shows = get();
      shows.add(FavoriteShow(
        url: details.url,
        title: details.title,
        description: details.description,
        image: details.image,
      ));
      await set(shows);
    }
  }

  Future<void> remove(Show details) async {
    if (isPresent(details.url)) {
      final favoriteShows = get();
      favoriteShows.removeWhere((show) => show.url == details.url);
      await set(favoriteShows);
    }
  }
}
