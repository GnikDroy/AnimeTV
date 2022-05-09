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
  late Future<List<RecentEpisode>> popularList;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  Future<void> onRefresh() {
    setState(() {
      popularList = Api.getRecentEpisodes();
    });
    return popularList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: popularList,
      builder:
          (BuildContext context, AsyncSnapshot<List<RecentEpisode>> snapshot) {
        if (snapshot.hasData) {
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
              itemBuilder: (_, index) =>
                  RecentEpisodeCard(snapshot.data![index]),
              itemCount: snapshot.data!.length,
            ),
          );
        } else if (snapshot.hasError) {
          return genericNetworkError;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
