import 'package:anime_tv/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:collection';
import 'package:anime_tv/api.dart';

class ViewEpisode extends StatefulWidget {
  String url;
  ViewEpisode({Key? key, required this.url}) : super(key: key);

  @override
  State<ViewEpisode> createState() => _ViewEpisodeState();
}

class _ViewEpisodeState extends State<ViewEpisode> {
  InAppWebViewController? webViewController;
  Map<String, dynamic>? details;
  bool error = false;

  @override
  void initState() {
    get_episode_details(widget.url).then(
      (details) {
        if (mounted) {
          setState(() {
            if (details.containsKey('url') && details['url'] != null) {
              this.details = details;
            } else {
              error = true;
            }
          });
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            error = true;
          });
        }
      },
    );
    super.initState();
  }

  Widget get_web_view() {
    const userAgent =
        "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
    const qol_improvement_script_src = '''
        vp.poster(null);
        document.querySelector('div#d-player>p').remove();
        document.querySelector('div.container').classList.add('container-fluid');
        document.querySelector('div.container').classList.remove('container');
    ''';
    final qol_improvement_script = UserScript(
        source: qol_improvement_script_src,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);
    final webview = InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(details?['url'] as String)),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(userAgent: userAgent)),
      initialUserScripts: UnmodifiableListView([qol_improvement_script]),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
    );

    return webview;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(
      child: CircularProgressIndicator(),
    );

    if (details != null) {
      body = get_web_view();
    }
    return Scaffold(
      appBar: get_app_bar(context, Colors.red),
      body: body,
    );
  }
}
