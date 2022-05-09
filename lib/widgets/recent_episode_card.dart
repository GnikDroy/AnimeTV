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
    final image = (details.cover.isEmpty
        ? const AssetImage('assets/cover_placeholder.jpg')
        : NetworkImage(details.cover)) as ImageProvider;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ViewEpisodeRoute.routeName,
          arguments: details.url,
        );
      },
      child: ImageCard(
        title: details.title,
        image: image,
      ),
    );
  }
}
