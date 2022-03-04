import 'package:flutter/material.dart';
import 'package:anime_tv/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anime_tv/pages/view_episode.dart';
import 'package:anime_tv/app_bar.dart';

class ShowDetailPage extends StatelessWidget {
  const ShowDetailPage({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: get_app_bar(context, Colors.red),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 18, 20, 36),
                Color.fromARGB(255, 33, 36, 59),
                // Color.fromARGB(255, 53, 53, 53),
              ]),
        ),
        child: ShowDetailView(url: url),
      ),
    );
  }
}

class ShowDetailView extends StatefulWidget {
  final String url;

  const ShowDetailView({Key? key, required this.url}) : super(key: key);

  @override
  State<ShowDetailView> createState() => _ShowDetailViewState();
}

class _ShowDetailViewState extends State<ShowDetailView> {
  var details = ShowDetails();
  bool load_complete = false;
  bool load_error = false;

  @override
  void initState() {
    get_show_details(widget.url).then(
      (details) {
        if (mounted) {
          setState(() {
            this.details = details;
            load_complete = true;
            load_error = false;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            load_error = true;
            load_complete = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (load_error) {
      return Text("Cannot fetch");
    } else if (!load_complete) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final cover = Container(
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

class ShowDescription extends StatelessWidget {
  const ShowDescription({Key? key, required this.details}) : super(key: key);
  final ShowDetails details;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      details.title ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );

    final controls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: 0.6,
          child: Text(
            '${details.episodeList?.length ?? 0} Episodes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.star, color: Colors.amber),
        ),
      ],
    );

    final genreTags = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (details.genreList ?? [])
          .map(
            (x) => Chip(
              backgroundColor: Colors.deepPurple,
              label: Text(
                x,
              ),
            ),
          )
          .toList(),
    );

    final plot = Text(
      details.description ?? '',
      style: TextStyle(fontSize: 16, height: 1.4),
    );

    final description = Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          title,
          const SizedBox(height: 15),
          controls,
          const SizedBox(height: 15),
          plot,
          const SizedBox(height: 15),
          genreTags,
        ],
      ),
    );
    return description;
  }
}

class EpisodeList extends StatelessWidget {
  EpisodeList({Key? key, required this.details, required this.reorder})
      : super(key: key);

  final ShowDetails details;
  void Function() reorder;

  @override
  Widget build(BuildContext context) {
    final episode_list = (details.episodeList ?? []).map(
      (ep) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 48, 48, 48),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewEpisode(url: ep.url!)),
                );
              },
              icon: Icon(Icons.play_circle),
              label: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  ep.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    ).toList();

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: reorder,
              icon: const Icon(Icons.sort_by_alpha),
            ),
          ),
          ...episode_list,
        ],
      ),
    );
  }
}
