import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/widgets/recent_episode_card.dart';

class RecentEpisodesGrid extends StatefulWidget {
  const RecentEpisodesGrid({Key? key}) : super(key: key);

  @override
  _RecentEpisodesGridState createState() => _RecentEpisodesGridState();
}

class _RecentEpisodesGridState extends State<RecentEpisodesGrid> {
  var popularList = <RecentEpisode>[];
  bool loadComplete = false;
  bool loadError = false;

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  Future<void> onRefresh() {
    return Api.getRecentEpisodes().then(
      (list) {
        if (mounted) {
          setState(() {
            popularList = list;
            loadComplete = true;
            loadError = false;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            loadError = true;
            loadComplete = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadError) {
      return genericNetworkError;
    } else if (!loadComplete) {
      return const Center(child: CircularProgressIndicator());
    }

    const double extent = 300;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: extent,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: extent / RecentEpisodeCard.height,
        ),
        itemBuilder: (_, index) => RecentEpisodeCard(popularList[index]),
        itemCount: popularList.length,
      ),
    );
  }
}
