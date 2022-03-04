import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/utils.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  var favorites = <ShowDetails>[];

  @override
  void initState() {
    getFavorites().then((value) {
      if (mounted) {
        setState(() {
          favorites = value.map(ShowDetails.fromMap).toList();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: favorites.map((e) => Text(e.title ?? '')).toList(),
    );
  }
}
