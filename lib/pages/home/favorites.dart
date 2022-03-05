import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/routes.dart';
import 'package:anime_tv/preferences.dart';
import 'package:anime_tv/widgets/image_card.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  var favorites = <ShowDetails>[];
  static const double cardHeight = 400;

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  Future<void> onRefresh() {
    return FavoriteShowPreferences.get().then((value) {
      if (mounted) {
        setState(() {
          favorites = value.map(ShowDetails.fromMap).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (final details in favorites) {
      final image = (details.image == null
          ? const AssetImage('assets/cover_placeholder.jpg')
          : NetworkImage('https:' + details.image!)) as ImageProvider;

      final title = details.title ?? '';
      widgets.add(
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ShowDetailRoute.routeName,
              arguments: details.url!,
            );
          },
          child: ImageCard(title: title, image: image, height: cardHeight),
        ),
      );
    }

    const double extent = 300;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: extent,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: extent / (cardHeight),
        ),
        itemBuilder: (_, index) => widgets[index],
        itemCount: widgets.length,
      ),
    );
  }
}
