import 'package:flutter/material.dart';
import 'package:anime_tv/routes.dart';
import 'package:anime_tv/widgets/image_card.dart';
import 'package:anime_tv/api/models.dart';

class RecentEpisodeCard extends StatelessWidget {
  final RecentEpisode details;
  static const double height = 400;

  const RecentEpisodeCard(this.details, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = (details.image == null
        ? const AssetImage('assets/cover_placeholder.jpg')
        : NetworkImage('https:' + details.image!)) as ImageProvider;

    final title = details.episode.title ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ViewEpisodeRoute.routeName,
          arguments: details.episode.url!,
        );
      },
      child: ImageCard(
        title: title,
        image: image,
      ),
    );
  }
}
