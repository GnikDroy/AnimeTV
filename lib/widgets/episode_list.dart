import 'package:anime_tv/routes.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';
import 'package:provider/provider.dart';
import 'package:anime_tv/models.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class EpisodeList extends StatelessWidget {
  final Show details;
  final void Function() reorder;

  const EpisodeList({Key? key, required this.details, required this.reorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final episodeList = details.episodeList.map(
      (ep) {
        return Consumer<WatchedEpisodes>(
            builder: (context, watchedUrls, child) {
          return PreferenceBuilder(
            preference: watchedUrls.preference,
            builder: (BuildContext context, _) {
              final bool isWatched = watchedUrls.isPresent(ep.url);
              final opacity = isWatched ? 0.6 : 1.0;
              return Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ViewEpisodeRoute.routeName,
                        arguments: ep.url,
                      );
                    },
                    icon: Opacity(
                      opacity: opacity,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.white,
                      ),
                    ),
                    label: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Opacity(
                          opacity: opacity,
                          child: Text(
                            ep.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
      },
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: reorder,
              icon: const Icon(Icons.sort_by_alpha),
            ),
          ),
          ...episodeList,
        ],
      ),
    );
  }
}
