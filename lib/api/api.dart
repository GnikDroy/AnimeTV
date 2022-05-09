library api;

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:anime_tv/api/models.dart';
import 'package:flutter/foundation.dart';

class Api {
  static const server = 'https://www.wcostream.com';

  static const statusOk = 200;

  static Future<StreamUrls> getStreamUrls(String apiUrl) async {
    final response = await http.get(
      Uri.parse(Api.server + apiUrl),
      headers: {
        'referrer': Api.server,
        'x-requested-with': 'XMLHttpRequest',
      },
    );
    final json = Map<String, String>.from(jsonDecode(response.body));
    final ret = StreamUrls();
    if (json['server'] != '') {
      if (json['hd'] != '') {
        ret.hd.add("${json['server']}/getvid?evid=${json['hd']}");
      }
      if (json['enc'] != '') {
        ret.sd.add("${json['server']}/getvid?evid=${json['enc']}");
      }
    }
    if (json['cdn'] != '') {
      if (json['hd'] != '') {
        ret.hd.add("${json['cdn']}/getvid?evid=${json['hd']}");
      }
      if (json['enc'] != '') {
        ret.sd.add("${json['cdn']}/getvid?evid=${json['enc']}");
      }
    }
    return ret;
  }

  static Future<String?> getJsonApiLink(String hiddenLink) async {
    final response = await http.get(Uri.parse(hiddenLink));
    return RegExp(r'get\("(.*?)"\)').firstMatch(response.body)?.group(1);
  }

  static String? _decodeVideoLink(String b64, int num) {
    final js = b64
        .split(',')
        .map((x) => x.trim())
        .map(base64.decoder.convert)
        .map(utf8.decode)
        .map((x) => x.replaceAll(RegExp(r'[^0-9]'), ''))
        .map(int.parse)
        .map((x) => (x - num))
        .map(String.fromCharCode)
        .join('');
    final url = RegExp(r'src="(.*?)"').firstMatch(js)?.group(1);
    return url == null ? null : server + url;
  }

  static Future<EpisodeDetails> getEpisodeDetails(String url) async {
    var details = EpisodeDetails(url: url, streamUrls: StreamUrls());

    final response = await http.get(Uri.parse(url));
    final document = parser.parse(response.body);
    final videoText = document.querySelector('div.iltext')?.text.trim() ?? '';
    if (response.statusCode == statusOk) {
      var b64 = RegExp(r'\[.*\]')
          .firstMatch(videoText)
          ?.group(0)
          ?.replaceAll(RegExp(r'[\[\]"]'), '');
      var num = int.tryParse(
          RegExp(r'\)\) - (\d+)').firstMatch(videoText)?.group(1) ?? '');

      if (b64 != null && num != null) {
        final videoLink = _decodeVideoLink(b64, num);
        if (videoLink != null) {
          final jsonUrl = await getJsonApiLink(videoLink);
          if (jsonUrl != null) {
            details.streamUrls = await getStreamUrls(jsonUrl);
          }
        }
      }
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return details;
  }

  static Future<ShowDetails> getShowDetails(String url) async {
    var details = ShowDetails(url: url);

    final response = await http.get(Uri.parse(server + url));
    if (response.statusCode == statusOk) {
      final document = parser.parse(response.body);

      details.title = document.querySelector('td>h2')?.text.trim();

      details.image =
          document.querySelector('div#cat-img-desc>div>img')?.attributes['src'];

      details.description =
          document.querySelector('div#cat-img-desc>.iltext')?.text.trim();

      details.genreList = document
          .querySelectorAll('div#cat-genre>.wcobtn>a')
          .map((g) => g.text.trim())
          .toList();

      details.episodeList = document
          .querySelectorAll('div#catlist-listview>ul>li>a')
          .map((ep) => EpisodeDetails(
                title: ep.text.trim(),
                url: ep.attributes['href'],
                streamUrls: StreamUrls(),
              ))
          .toList();
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return details;
  }

  static Future<List<ShowDetails>> getCatalogue(String category) async {
    final response = await http.get(Uri.parse(server + category));
    if (response.statusCode == statusOk) {
      final document = parser.parse(response.body);
      var showList = document
          .querySelectorAll('div.ddmcc>ul>ul>li>a')
          .map(
            (e) => ShowDetails(
              title: e.text.trim(),
              url: e.attributes['href'] ?? '',
            ),
          )
          .where((e) => e.url != '')
          .toList();
      return showList;
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return [];
  }

  static Future<List<ShowDetails>> searchShow(String query) async {
    final body = 'catara=${Uri.encodeQueryComponent(query)}&konuara=series';
    final response = await http.post(
      Uri.parse('$server/search'),
      headers: {"content-type": "application/x-www-form-urlencoded"},
      body: utf8.encode(body),
    );
    if (response.statusCode == statusOk) {
      final document = parser.parse(response.body);
      return document
          .querySelectorAll('div.iccerceve')
          .map(
            (x) => ShowDetails(
              title: x.children[0].children[0].text.trim(),
              url: x.children[0].children[0].attributes['href'],
              image: x.children[1].children[0].attributes['src'],
            ),
          )
          .where((e) => e.url != null)
          .toList();
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return [];
  }

  static Future<List<RecentEpisode>> getRecentEpisodes() async {
    final response = await http.get(Uri.parse(server));
    if (response.statusCode == statusOk) {
      final document = parser.parse(response.body);
      var recentEpisode = document
          .querySelectorAll('ul.items>li')
          .map(
            (e) => RecentEpisode(
              image: e.children[0].children[0].children[0].attributes['src'],
              episode: EpisodeDetails(
                title: e.children[1].text.trim(),
                url: e.children[0].children[0].attributes['href'],
                streamUrls: StreamUrls(),
              ),
            ),
          )
          .where((e) => e.episode.url != null && e.image != null)
          .toList();
      return recentEpisode;
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return [];
  }
}
