import 'pages/view_episode.dart';
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
