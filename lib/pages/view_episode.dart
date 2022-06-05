import 'package:anime_tv/widgets/better_player_custom_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anime_tv/models.dart';
import 'package:anime_tv/widgets/error_card.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    final watchedEpisodes =
        Provider.of<WatchedEpisodes>(context, listen: false);
    watchedEpisodes.add(widget.url);

    final startDuration = watchedEpisodes
        .get()
        .firstWhere((x) => x.url == widget.url, orElse: () => WatchedEpisode())
        .timestamp;

    final config = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      expandToFill: true,
      autoPlay: true,
      startAt: startDuration,
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
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
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: episode,
      builder: (_, AsyncSnapshot<Episode> snapshot) {
        if (snapshot.hasData) {
          _controller.setBetterPlayerControlsConfiguration(
            BetterPlayerControlsConfiguration(
              playerTheme: BetterPlayerTheme.custom,
              customControlsBuilder:
                  (controller, onControlsVisibilityChanged) =>
                      CustomPlayerMaterialControls(
                onControlsVisibilityChanged: onControlsVisibilityChanged,
                controlsConfiguration: const BetterPlayerControlsConfiguration(
                    enableFullscreen: false),
                nextUrl: snapshot.data!.next,
                prevUrl: snapshot.data!.prev,
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: snapshot.hasData
              ? BetterPlayer(controller: _controller)
              : snapshot.hasError
                  ? genericNetworkError
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
        );
      },
    );
  }
}
