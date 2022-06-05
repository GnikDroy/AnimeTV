import 'package:anime_tv/models.dart';
import 'package:anime_tv/routes.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/widgets/recent_episode_card.dart';
import 'package:provider/provider.dart';

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
            child: Stack(
              children: [
                GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
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
                Consumer<LastEpisode>(builder: (context, lastEpisode, child) {
                  if (lastEpisode.get().isNotEmpty) {
                    return Positioned(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            ViewEpisodeRoute.routeName,
                            arguments: lastEpisode.get(),
                          );
                        },
                        icon: const Icon(Icons.movie),
                        label: const Text("Continue Watching"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                        ),
                      ),
                      bottom: 15,
                      right: 15,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
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
