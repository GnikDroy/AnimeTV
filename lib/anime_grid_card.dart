import 'package:flutter/material.dart';
import 'package:anime_tv/api.dart';

class AnimeGridCard extends StatelessWidget {
  const AnimeGridCard({Key? key, required this.details, this.height = 250.0})
      : super(key: key);
  final Map<String, dynamic> details;
  final double height;

  @override
  Widget build(BuildContext context) {
    Widget image = Image(
      image: NetworkImage('https:' + (details['image'] as String)),
      width: double.infinity,
      fit: BoxFit.cover,
      height: height,
    );

    Widget text = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 71, 51, 255),
          Color.fromARGB(255, 0, 132, 255),
        ]),
      ),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          details['title'] as String,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );

    Widget card = Card(
      elevation: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          image,
          text,
        ],
      ),
    );

    var rounded_card = ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(child: card),
    );
    return rounded_card;
  }
}
