import 'package:flutter/material.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/widgets/episode_list.dart';
import 'package:anime_tv/widgets/show_description.dart';

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
            height: MediaQuery.of(context).size.height / 2.0,
            width: double.infinity,
            child: FadeInImage(
              image: (snapshot.data!.image.isEmpty
                  ? const AssetImage('assets/cover_placeholder.jpg')
                  : NetworkImage(snapshot.data!.image)) as ImageProvider,
              placeholder: const AssetImage('assets/cover_placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          );

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                cover,
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
