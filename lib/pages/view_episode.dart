import 'package:anime_tv/models.dart';
import 'package:anime_tv/widgets/app_bar.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:provider/provider.dart';
import 'package:better_player/better_player.dart';

class ViewEpisode extends StatefulWidget {
  final String url;
  const ViewEpisode({Key? key, required this.url}) : super(key: key);

  @override
  State<ViewEpisode> createState() => _ViewEpisodeState();
}

class _ViewEpisodeState extends State<ViewEpisode> {
  late Future<Episode> episode;
  late BetterPlayerController _controller;
  late BetterPlayerDataSource _dataSource;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    final watchedEpisodes =
        Provider.of<WatchedEpisodes>(context, listen: false);
    watchedEpisodes.add(widget.url);

    final startDuration = watchedEpisodes
        .get()
        .firstWhere((x) => x.url == widget.url, orElse: () => WatchedEpisode())
        .timestamp;

    final config = BetterPlayerConfiguration(
      aspectRatio: 9 / 16,
      fit: BoxFit.contain,
      autoPlay: true,
      startAt: startDuration,
      fullScreenByDefault: true,
      autoDetectFullscreenDeviceOrientation: true,
    );

    _controller = BetterPlayerController(config);
    _controller.addEventsListener((event) async {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        final duration = await _controller.videoPlayerController?.position;
        if (duration != null) {
          await watchedEpisodes.setTimestamp(widget.url, duration);
        }
      }
    });

    episode = () async {
      final details = await Api.getEpisodeDetails(widget.url);
      if (details.hasVideoSource()) {
        _dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          details.getSingleVideoSource(),
          resolutions: details.getVideoResolutions(),
        );
        _controller.setupDataSource(_dataSource);
      } else {
        throw Exception('No video sources available.');
      }
      return details;
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: episode,
      builder: (_, AsyncSnapshot<Episode> snapshot) {
        Widget? body;
        if (snapshot.hasData) {
          body = LayoutBuilder(
            builder: (_, constraints) => AspectRatio(
              aspectRatio: constraints.maxWidth / constraints.maxHeight,
              child: BetterPlayer(controller: _controller),
            ),
          );
        } else if (snapshot.hasError) {
          body = genericNetworkError;
        } else {
          body = const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: const AnimeTVAppBar(),
          body: body,
        );
      },
    );
  }
}
