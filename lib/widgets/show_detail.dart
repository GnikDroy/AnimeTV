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
  var details = ShowDetails();
  bool loadComplete = false;
  bool loadError = false;

  @override
  void initState() {
    get_show_details(widget.url).then(
      (details) {
        if (mounted) {
          setState(() {
            this.details = details;
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
        image: (details.image == null
            ? const AssetImage('assets/cover_placeholder.jpg')
            : NetworkImage('https:' + details.image!)) as ImageProvider,
        placeholder: const AssetImage('assets/cover_placeholder.jpg'),
        fit: BoxFit.cover,
      ),
    );

    final stack = ListView(
      children: [
        cover,
        ShowDescription(details: details),
        EpisodeList(
          details: details,
          reorder: () {
            setState(() {
              details.episodeList = details.episodeList?.reversed.toList();
            });
          },
        ),
      ],
    );
    return stack;
  }
}
