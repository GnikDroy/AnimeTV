import 'dart:convert';
import 'package:anime_tv/api/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteShowPreferences {
  static const String key = 'favoriteShows';

  static Future<List<Map<String, String?>>> get() async {
    return SharedPreferences.getInstance().then((pref) {
      final favoriteShowsStr = pref.getString(key);
      var favoriteShowsDyn = <dynamic>[];
      if (favoriteShowsStr != null) {
        favoriteShowsDyn = jsonDecode(favoriteShowsStr);
      }
      final favoriteShows =
          favoriteShowsDyn.map((e) => Map<String, String?>.from(e)).toList();
      return favoriteShows;
    });
  }

  static void set(List<Map<String, String?>> favorites) async {
    return SharedPreferences.getInstance().then((pref) {
      pref.setString(key, json.encode(favorites));
    });
  }

  static Future<bool> isPresent(String? url) async {
    return SharedPreferences.getInstance().then((pref) {
      final favoriteShowsStr = pref.getString(key);
      if (favoriteShowsStr != null) {
        List<dynamic> favoriteShows = jsonDecode(favoriteShowsStr);
        for (final dynShow in favoriteShows) {
          Map<String, String> show = Map<String, String>.from(dynShow);
          if (ShowDetails.fromMap(show).url == url) {
            return true;
          }
        }
      }
      return false;
    });
  }

  static add(ShowDetails details) async {
    isPresent(details.url).then((present) {
      if (!present) {
        SharedPreferences.getInstance().then((pref) {
          get().then((favoriteShows) {
            favoriteShows.add(details.toMap());
            pref.setString(key, json.encode(favoriteShows));
          });
        });
      }
    });
  }

  static remove(ShowDetails details) async {
    isPresent(details.url).then((present) {
      if (present) {
        SharedPreferences.getInstance().then((pref) {
          get().then((favoriteShows) {
            favoriteShows.removeWhere((show) => show['url'] == details.url);
            pref.setString(key, json.encode(favoriteShows));
          });
        });
      }
    });
  }
}

class WatchedEpisodesPreferences {
  static const key = 'watchedEpisodes';

  static set(List<String> urls) async {
    return SharedPreferences.getInstance()
        .then((pref) => pref.setStringList(key, urls));
  }

  static Future<List<String>> get() async {
    return SharedPreferences.getInstance()
        .then((pref) => pref.getStringList(key) ?? []);
  }

  static Future<bool> isPresent(String url) async {
    return get().then((urls) => urls.contains(url));
  }

  static add(String url) async {
    if (!await isPresent(url)) {
      var urls = await get();
      urls.add(url);
      await set(urls);
    }
  }
}
