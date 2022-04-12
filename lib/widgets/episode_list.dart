import 'package:anime_tv/routes.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';
import 'package:provider/provider.dart';
import 'package:anime_tv/models.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class EpisodeList extends StatelessWidget {
  final ShowDetails details;
  final void Function() reorder;

  const EpisodeList({Key? key, required this.details, required this.reorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final episodeList = (details.episodeList ?? []).map(
      (ep) {
        return Consumer<WatchedEpisodes>(
            builder: (context, watchedUrls, child) {
          return PreferenceBuilder(
            preference: watchedUrls.preference,
            builder: (BuildContext context, List<String> _) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
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
                        arguments: ep.url!,
                      );
                    },
                    icon: Icon(Icons.play_circle,
                        color: watchedUrls.isPresent(ep.url ?? '')
                            ? Colors.grey
                            : Colors.white),
                    label: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        ep.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
