import 'package:flutter/material.dart';
import 'package:anime_tv/pages/home.dart';
import 'package:anime_tv/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  runApp(const AnimeTV());
}

class AnimeTV extends StatelessWidget {
  const AnimeTV({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anime TV',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          ViewEpisodeRoute.routeName: (context) => const ViewEpisodeRoute(),
          ShowDetailRoute.routeName: (context) => const ShowDetailRoute(),
        });
  }
}
