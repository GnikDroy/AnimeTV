import 'dart:io' show Platform;

import 'package:anime_tv/models.dart';
import 'package:anime_tv/widgets/app_bar.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:provider/provider.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';

class ViewEpisode extends StatefulWidget {
  final String url;
  const ViewEpisode({Key? key, required this.url}) : super(key: key);

  @override
  State<ViewEpisode> createState() => _ViewEpisodeState();
}

class _ViewEpisodeState extends State<ViewEpisode> {
  EpisodeDetails? details;
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  bool loadError = false;

  @override
  void initState() {
    const betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 9 / 16,
      fit: BoxFit.contain,
      autoPlay: true,
      fullScreenByDefault: true,
      autoDetectFullscreenDeviceOrientation: true,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    Provider.of<WatchedEpisodes>(context, listen: false).add(widget.url);

    Api.getEpisodeDetails(widget.url).then(
      (details) {
        if (mounted) {
          setState(() {
            if (details.hasStreams()) {
              this.details = details;
              _betterPlayerDataSource = BetterPlayerDataSource(
                BetterPlayerDataSourceType.network,
                details.getAnyStream()!,
                resolutions: details.getResolutions(),
              );
              _betterPlayerController.setupDataSource(_betterPlayerDataSource);
            } else {
              loadError = true;
            }
          });
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            loadError = true;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;

    if (loadError) {
      body = genericNetworkError;
    } else {
      body = LayoutBuilder(
        builder: (context, constraints) => AspectRatio(
          aspectRatio: constraints.maxWidth / constraints.maxHeight,
          child: BetterPlayer(controller: _betterPlayerController),
        ),
      );
    }
    return Scaffold(
      appBar: const AnimeTVAppBar(),
      body: body,
    );
  }
}
