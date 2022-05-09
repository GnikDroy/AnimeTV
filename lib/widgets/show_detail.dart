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
  var details = Show();
  bool loadComplete = false;
  bool loadError = false;

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
    return Api.getShowDetails(widget.url).then(
      (details) {
        setState(() {
          this.details = details;
          loadComplete = true;
          loadError = false;
        });
      },
      onError: (err) {
        setState(() {
          loadError = true;
          loadComplete = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadError) {
      return genericNetworkError;
    } else if (!loadComplete) {
      return const Center(child: CircularProgressIndicator());
    }

    final cover = SizedBox(
      height: MediaQuery.of(context).size.height / 2.0,
      width: double.infinity,
      child: FadeInImage(
        image: (details.image.isEmpty
            ? const AssetImage('assets/cover_placeholder.jpg')
            : NetworkImage('https:' + details.image)) as ImageProvider,
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
          ShowDescription(details: details),
          EpisodeList(
            details: details,
            reorder: () {
              setState(() {
                details.episodeList = details.episodeList.reversed.toList();
              });
            },
          ),
        ],
      ),
    );
  }
}
