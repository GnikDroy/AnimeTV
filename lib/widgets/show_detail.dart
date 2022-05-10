import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: details,
      builder: (context, AsyncSnapshot<Show> snapshot) {
        if (snapshot.hasData) {
          final cover = SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: FadeInImage(
              image: (snapshot.data!.image.isEmpty
                  ? const AssetImage('assets/cover_placeholder.jpg')
                  : NetworkImage(snapshot.data!.image)) as ImageProvider,
              placeholder: const AssetImage('assets/cover_placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          );

          final genreTags = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: snapshot.data!.genreList
                .map(
                  (genre) => Chip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors
                        .primaries[genre.hashCode % Colors.accents.length]
                        .darken(),
                    label: Text(
                      genre,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
          );

          final stack = SizedBox(
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

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                stack,
                ShowDescription(details: snapshot.data!),
                EpisodeList(
                  details: snapshot.data!,
                  reorder: () {
                    setState(() {
                      snapshot.data!.episodeList =
                          snapshot.data!.episodeList.reversed.toList();
                    });
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return genericNetworkError;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
