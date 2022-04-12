import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final double height;
  final ImageProvider image;
  final ImageProvider placeholder;
  final String title;

  const ImageCard({
    Key? key,
    required this.title,
    required this.image,
    this.placeholder = const AssetImage('assets/cover_placeholder.jpg'),
    this.height = 400.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cover = SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FadeInImage(
        image: image,
        placeholder: placeholder,
        fit: BoxFit.cover,
      ),
    );

    final overlay = Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black45,
    );

    final titleWidget = Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );

    final stack = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        cover,
        overlay,
        titleWidget,
      ],
    );

    final roundedCard = ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: stack,
    );

    return roundedCard;
  }
}
