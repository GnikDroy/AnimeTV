import 'package:anime_tv/models.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ShowDescription extends StatefulWidget {
  const ShowDescription({Key? key, required this.details}) : super(key: key);
  final Show details;

  @override
  State<ShowDescription> createState() => _ShowDescriptionState();
}

class _ShowDescriptionState extends State<ShowDescription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      widget.details.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );

    final episodeText = widget.details.episodeList.isEmpty
        ? ''
        : '${widget.details.episodeList.length} Episodes';

    final controls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: 0.6,
          child: Text(
            episodeText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Consumer<FavoriteShows>(builder: (context, favoriteShows, child) {
          return PreferenceBuilder(
              preference: favoriteShows.preference,
              builder: (BuildContext context, String _) {
                return IconButton(
                  onPressed: () => favoriteShows.toggle(widget.details),
                  icon: Icon(Icons.star,
                      color: favoriteShows.isPresent(widget.details.url)
                          ? Colors.amber
                          : null),
                );
              });
        }),
        // IconButton(
        //   onPressed: () => {},
        //   icon: Icon(Icons.star, color: true ? Colors.amber : null),
        // ),
      ],
    );

    final genreTags = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.details.genreList
          .map((x) => Chip(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Text(x),
              ))
          .toList(),
    );

    final plot = Text(
      widget.details.description,
      style: const TextStyle(fontSize: 16, height: 1.4),
    );

    final description = Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          title,
          const SizedBox(height: 15),
          controls,
          const SizedBox(height: 15),
          plot,
          const SizedBox(height: 15),
          genreTags,
        ],
      ),
    );
    return description;
  }
}
