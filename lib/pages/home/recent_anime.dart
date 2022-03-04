import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/widgets/anime_grid_card.dart';

class RecentAnimeGrid extends StatefulWidget {
  final double itemHeight = 350;
  const RecentAnimeGrid({Key? key}) : super(key: key);

  @override
  _RecentAnimeGridState createState() => _RecentAnimeGridState();
}

class _RecentAnimeGridState extends State<RecentAnimeGrid> {
  var popularList = <ShowDetails>[];
  bool loadComplete = false;
  bool loadError = false;

  @override
  void initState() {
    get_popular().then(
      (list) {
        if (mounted) {
          setState(() {
            popularList = list;
            loadComplete = true;
            loadError = false;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            loadError = true;
            loadComplete = false;
          });
        }
      },
    );
    super.initState();
  }

  Widget itemBuilder(BuildContext context, int index) {
    return AnimeGridCard(
      popularList[index],
      height: widget.itemHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadError) {
      return genericNetworkError;
    } else if (!loadComplete) {
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 300 / (widget.itemHeight),
      ),
      itemBuilder: itemBuilder,
      itemCount: popularList.length,
    );
  }
}
