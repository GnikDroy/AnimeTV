import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';

class ShowDescription extends StatelessWidget {
  const ShowDescription({Key? key, required this.details}) : super(key: key);
  final ShowDetails details;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      details.title ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );

    final controls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: 0.6,
          child: Text(
            '${details.episodeList?.length ?? 0} Episodes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.star, color: Colors.amber),
        ),
      ],
    );

    final genreTags = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (details.genreList ?? [])
          .map(
            (x) => Chip(
              backgroundColor: Colors.deepPurple,
              label: Text(
                x,
              ),
            ),
          )
          .toList(),
    );

    final plot = Text(
      details.description ?? '',
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
