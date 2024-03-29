import 'package:flutter/material.dart';

import 'package:skeleton_text/skeleton_text.dart';

import 'package:anime_tv/widgets/error_card.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/widgets/episode_list.dart';
import 'package:anime_tv/widgets/show_description.dart';
import 'package:anime_tv/utils.dart';

class ShowDetailView extends StatefulWidget {
  final String url;

  const ShowDetailView({Key? key, required this.url}) : super(key: key);

  @override
  State<ShowDetailView> createState() => _ShowDetailViewState();
}

class _ShowDetailViewState extends State<ShowDetailView> {
  late Future<Show> details;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  Future<void> onRefresh() {
    setState(() {
      details = Api.getShowDetails(widget.url);
    });
    return details;
  }

  Widget buildSkeleton(context) {
    final skeleton = SkeletonAnimation(
      shimmerColor: Theme.of(context).backgroundColor,
      shimmerDuration: 800,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.lighten(),
        ),
      ),
    );

    final coverSkeleton = SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.5,
      child: skeleton,
    );

    final descriptionSkeleton = Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: 30,
            child: skeleton,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: 20,
                child: skeleton,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: 20,
                child: skeleton,
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(width: double.infinity, height: 150, child: skeleton),
        ],
      ),
    );

    final episodeListSkeleton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: List.generate(12, (index) {
          if (index % 2 == 0) {
            return SizedBox(
              width: double.infinity,
              height: 40,
              child: skeleton,
            );
          } else {
            return const SizedBox(height: 8);
          }
        }),
      ),
    );

    return ListView(
      children: [
        coverSkeleton,
        descriptionSkeleton,
        episodeListSkeleton,
      ],
    );
  }

  Widget buildCoverWithOverlay(Show show) {
    final cover = SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FadeInImage(
        image: (show.image.isEmpty
            ? const AssetImage('assets/cover_placeholder.jpg')
            : NetworkImage(show.image)) as ImageProvider,
        placeholder: const AssetImage('assets/cover_placeholder.jpg'),
        fit: BoxFit.cover,
      ),
    );

    final genreTags = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: show.genreList
          .map((genre) => Chip(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors
                    .primaries[genre.hashCode % Colors.accents.length]
                    .darken(),
                label: Text(
                  genre,
                  style: const TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
    );

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.5,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          cover,
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black12,
          ),
          Padding(
            child: genreTags,
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: details,
      builder: (context, AsyncSnapshot<Show> snapshot) {
        if (snapshot.hasData) {
          final show = snapshot.data!;
          final coverWithOverlay = buildCoverWithOverlay(show);
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                coverWithOverlay,
                ShowDescription(details: show),
                EpisodeList(
                  details: show,
                  reorder: () {
                    setState(() {
                      show.episodeList = show.episodeList.reversed.toList();
                    });
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return genericNetworkError;
        } else {
          return buildSkeleton(context);
        }
      },
    );
  }
}
