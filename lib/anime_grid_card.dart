import 'package:anime_tv/pages/view_episode.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api.dart';

class AnimeGridCard extends StatelessWidget {
  const AnimeGridCard({Key? key, required this.details, this.height = 200.0})
      : super(key: key);
  final ShowDetails details;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cover = SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FadeInImage(
        image: (details.image == null
            ? const AssetImage('assets/cover_placeholder.jpg')
            : NetworkImage('https:' + details.image!)) as ImageProvider,
        placeholder: const AssetImage('assets/cover_placeholder.jpg'),
        fit: BoxFit.cover,
      ),
    );

    final overlay = Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black45,
    );

    final title = Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        details.title ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );

    final stack = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        cover,
        overlay,
        title,
      ],
    );

    var rounded_card = ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: stack,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewEpisode(url: details.url!)),
        );
      },
      child: rounded_card,
    );
  }
}
