import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/models.dart';
import 'package:anime_tv/routes.dart';
import 'package:anime_tv/widgets/image_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteShowsView extends StatelessWidget {
  static const double cardHeight = 400;
  const FavoriteShowsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteShows>(builder: (context, favoriteShows, child) {
      var widgets = <Widget>[];
      final favorites = favoriteShows.get().map(Show.fromMap).toList();

      for (final details in favorites) {
        final image = (details.image.isEmpty
            ? const AssetImage('assets/cover_placeholder.jpg')
            : NetworkImage('https:' + details.image)) as ImageProvider;

        widgets.add(
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ShowDetailRoute.routeName,
                arguments: details.url,
              );
            },
            child: ImageCard(
                title: details.title, image: image, height: cardHeight),
          ),
        );
      }

      const double extent = 300;
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: extent,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: extent / (cardHeight),
        ),
        itemBuilder: (_, index) => widgets[index],
        itemCount: widgets.length,
      );
    });
  }
}
