import 'package:anime_tv/routes.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';

class AnimeGridCard extends StatelessWidget {
  final ShowDetails details;
  final double height;

  const AnimeGridCard(this.details, {Key? key, this.height = 200.0})
      : super(key: key);

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

    final roundedCard = ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: stack,
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ViewEpisodeRoute.routeName,
          arguments: details.url!,
        );
      },
      child: roundedCard,
    );
  }
}
