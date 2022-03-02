import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:collection';

class ViewEpisodeWidget extends StatefulWidget {
  const ViewEpisodeWidget({Key? key}) : super(key: key);

  @override
  State<ViewEpisodeWidget> createState() => _ViewEpisodeWidgetState();
}

class _ViewEpisodeWidgetState extends State<ViewEpisodeWidget> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    const userAgent =
        "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
    const qol_improvement_script_src = '''
        vp.poster(null);
        document.querySelector('div#d-player>p').remove();
        document.querySelector('div.container').classList.add('container-fluid');
        document.querySelector('div.container').classList.remove('container');
    ''';
    var qol_improvement_script = UserScript(
        source: qol_improvement_script_src,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              'https://www.wcostream.com/inc/cizgifilmlerizle/embed.php?file=Blade%20Runner%20Black%20Lotus%20Dubbed%2FWatch%20Blade%20Runner-%20Black%20Lotus%20%28Dub%29%20Episode%2013.flv&hd=1&pid=603630&h=5fbd9e31d9bdd76faa5977f338e50b7d&t=1646222561&subd=ndisk')),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(userAgent: userAgent)),
      initialUserScripts: UnmodifiableListView([qol_improvement_script]),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
    );
  }
}
