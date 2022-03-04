import 'package:anime_tv/routes.dart';
import 'package:anime_tv/utils.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';

class EpisodeList extends StatefulWidget {
  final ShowDetails details;
  final void Function() reorder;

  const EpisodeList({Key? key, required this.details, required this.reorder})
      : super(key: key);

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  var watchedUrls = <String>[];

  @override
  void initState() {
    getWatchedEpisodeUrls().then((watched) {
      setState(() {
        watchedUrls = widget.details.episodeList
                ?.where((details) => watched.contains(details.url))
                .map((details) => details.url!)
                .toList() ??
            [];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final episodeList = (widget.details.episodeList ?? []).map(
      (ep) {
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
                  color: watchedUrls.contains(ep.url)
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
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: widget.reorder,
              icon: const Icon(Icons.sort_by_alpha),
            ),
          ),
          ...episodeList,
        ],
      ),
    );
  }
}
