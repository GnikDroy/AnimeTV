import 'package:anime_tv/pages/search_results.dart';
import 'package:anime_tv/pages/view_episode.dart';
import 'package:anime_tv/pages/show_detail_page.dart';
import 'package:flutter/material.dart';

class ViewEpisodeRoute extends StatelessWidget {
  static const routeName = '/viewEpisode';
  const ViewEpisodeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    return ViewEpisode(url: url);
  }
}

class ShowDetailRoute extends StatelessWidget {
  static const routeName = '/showDetails';
  const ShowDetailRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    return ShowDetailPage(url: url);
  }
}

class SearchResultsRoute extends StatelessWidget {
  static const routeName = '/searchResults';
  const SearchResultsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String query = ModalRoute.of(context)!.settings.arguments as String;
    return SearchResultsPage(query: query);
  }
}
