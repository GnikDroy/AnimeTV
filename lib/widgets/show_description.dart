import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/utils.dart';

class ShowDescription extends StatefulWidget {
  const ShowDescription({Key? key, required this.details}) : super(key: key);
  final ShowDetails details;

  @override
  State<ShowDescription> createState() => _ShowDescriptionState();
}

class _ShowDescriptionState extends State<ShowDescription> {
  bool _favorite = false;

  @override
  void initState() {
    isShowFavorite(widget.details.url).then((value) {
      if (mounted && value) {
        setState(() {
          _favorite = value;
        });
      }
    });
    super.initState();
  }

  void toggleFavorite() {
    void switchFavorite(_) {
      if (mounted) {
        setState(() {
          _favorite = !_favorite;
        });
      }
    }

    if (_favorite) {
      removeFavorite(widget.details).then(switchFavorite);
    } else {
      addFavorite(widget.details).then(switchFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      widget.details.title ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );

    final episodeText = (widget.details.episodeList ?? []).length == 0
        ? ''
        : '${widget.details.episodeList?.length} Episodes';

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
        IconButton(
          onPressed: () => toggleFavorite(),
          icon: Icon(Icons.star, color: _favorite ? Colors.amber : null),
        ),
      ],
    );

    final genreTags = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (widget.details.genreList ?? [])
          .map(
            (x) => Chip(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                x,
              ),
            ),
          )
          .toList(),
    );

    final plot = Text(
      widget.details.description ?? '',
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
