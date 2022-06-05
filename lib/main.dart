import 'package:flutter/material.dart';
import 'package:anime_tv/pages/home.dart';
import 'package:anime_tv/routes.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  final prefs = await StreamingSharedPreferences.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WatchedEpisodes(prefs)),
        ChangeNotifierProvider(create: (context) => FavoriteShows(prefs)),
        ChangeNotifierProvider(create: (context) => LastEpisode(prefs)),
      ],
      child: const AnimeTV(),
    ),
  );
}

class AnimeTV extends StatelessWidget {
  const AnimeTV({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anime TV',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          ViewEpisodeRoute.routeName: (context) => const ViewEpisodeRoute(),
          ShowDetailRoute.routeName: (context) => const ShowDetailRoute(),
          SearchResultsRoute.routeName: (context) => const SearchResultsRoute(),
        });
  }
}
