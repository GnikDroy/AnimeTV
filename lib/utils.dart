import 'dart:convert';
import 'package:anime_tv/api/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

Future<List<Map<String, String?>>> getFavorites() async {
  return SharedPreferences.getInstance().then((pref) {
    final favoriteShowsStr = pref.getString('favoriteShows');
    var favoriteShowsDyn = <dynamic>[];
    if (favoriteShowsStr != null) {
      favoriteShowsDyn = jsonDecode(favoriteShowsStr);
    }
    final favoriteShows =
        favoriteShowsDyn.map((e) => Map<String, String?>.from(e)).toList();
    return favoriteShows;
  });
}

void setFavorites(List<Map<String, String?>> favorites) async {
  return SharedPreferences.getInstance().then((pref) {
    pref.setString('favoriteShows', json.encode(favorites));
  });
}

Future<bool> isShowFavorite(String? url) async {
  return SharedPreferences.getInstance().then((pref) {
    final favoriteShowsStr = pref.getString('favoriteShows');
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

addFavorite(ShowDetails details) async {
  isShowFavorite(details.url).then((present) {
    if (!present) {
      SharedPreferences.getInstance().then((pref) {
        getFavorites().then((favoriteShows) {
          favoriteShows.add(details.toMap());
          pref.setString('favoriteShows', json.encode(favoriteShows));
        });
      });
    }
  });
}

removeFavorite(ShowDetails details) async {
  isShowFavorite(details.url).then((present) {
    if (present) {
      SharedPreferences.getInstance().then((pref) {
        getFavorites().then((favoriteShows) {
          favoriteShows.removeWhere((show) => show['url'] == details.url);
          pref.setString('favoriteShows', json.encode(favoriteShows));
        });
      });
    }
  });
}

setWatchedEpisodeUrls(List<String> urls) async {
  return SharedPreferences.getInstance()
      .then((pref) => pref.setStringList('watchedEpisodes', urls));
}

Future<List<String>> getWatchedEpisodeUrls() async {
  return SharedPreferences.getInstance()
      .then((pref) => pref.getStringList('watchedEpisodes') ?? []);
}

Future<bool> isWatchedEpisode(String url) async {
  return getWatchedEpisodeUrls().then((urls) => urls.contains(url));
}

addWatched(String url) async {
  if (!await isWatchedEpisode(url)) {
    var urls = await getWatchedEpisodeUrls();
    urls.add(url);
    await setWatchedEpisodeUrls(urls);
  }
}
