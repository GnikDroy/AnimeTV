import 'package:anime_tv/preferences.dart';
import 'package:anime_tv/widgets/app_bar.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:collection';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';

class ViewEpisode extends StatefulWidget {
  final String url;
  const ViewEpisode({Key? key, required this.url}) : super(key: key);

  @override
  State<ViewEpisode> createState() => _ViewEpisodeState();
}

class _ViewEpisodeState extends State<ViewEpisode> {
  InAppWebViewController? webViewController;
  EpisodeDetails? details;
  bool loadError = false;

  @override
  void initState() {
    Api.getEpisodeDetails(widget.url).then(
      (details) {
        if (mounted) {
          setState(() {
            if (details.videoLink != null) {
              this.details = details;
              WatchedEpisodesPreferences.add(widget.url);
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

  Widget getWebView() {
    const userAgent =
        "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
    const qolScriptSrc = '''
        vp.poster(null);
        document.querySelector('div#d-player>p').remove();
        document.querySelector('div.container').classList.add('container-fluid');
        document.querySelector('div.container').classList.remove('container');
    ''';
    final qolImprovementScript = UserScript(
        source: qolScriptSrc,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);
    final webview = InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(details!.videoLink!)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(userAgent: userAgent),
      ),
      initialUserScripts: UnmodifiableListView([qolImprovementScript]),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
    );

    return webview;
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;

    if (loadError) {
      body = genericNetworkError;
    } else if (details == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = getWebView();
    }

    return Scaffold(
      appBar: const AnimeTVAppBar(),
      body: body,
    );
  }
}
