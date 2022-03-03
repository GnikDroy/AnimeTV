import 'package:flutter/material.dart';
import 'package:anime_tv/api.dart';
import 'package:anime_tv/anime_grid_card.dart';

class Recent extends StatefulWidget {
  final double item_height = 350;
  const Recent({Key? key}) : super(key: key);

  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  var popular_list = <Map<String, dynamic>>[];
  bool load_complete = false;
  bool load_error = false;

  @override
  void initState() {
    get_popular().then(
      (anime_list) {
        if (mounted) {
          setState(() {
            popular_list = anime_list;
            load_complete = true;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          load_error = true;
        }
      },
    );
    super.initState();
  }

  Widget item_builder(BuildContext context, int index) {
    return AnimeGridCard(
      details: popular_list[index],
      height: widget.item_height,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (popular_list.length == 0 && !load_complete && !load_error) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (load_error) {
      return const Center(child: Text("Failed to load popular list"));
    } else {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 300 / (widget.item_height),
        ),
        itemBuilder: item_builder,
        itemCount: popular_list.length,
      );
    }
  }
}
