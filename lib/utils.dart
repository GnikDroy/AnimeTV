import 'dart:convert';
import 'package:anime_tv/api/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
