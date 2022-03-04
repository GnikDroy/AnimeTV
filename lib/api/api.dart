library api;

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:anime_tv/api/models.dart';

const server = 'https://www.wcostream.com';
const _statusOk = 200;

String? _decode_episode_link(String b64, int num) {
  final js = b64
      .split(',')
      .map((x) => x.trim())
      .map(base64.decoder.convert)
      .map(utf8.decode)
      .map((x) => x.replaceAll(new RegExp(r'[^0-9]'), ''))
      .map(int.parse)
      .map((x) => (x - num))
      .map(String.fromCharCode)
      .join('');
  final url = RegExp(r'src="(.*?)"').firstMatch(js)?.group(1);
  return url == null ? null : server + url;
}

Future<EpisodeDetails> get_episode_details(String url) async {
  var details = EpisodeDetails(url: url);

  final response = await http.get(Uri.parse(url));
  final document = parser.parse(response.body);
  final video_text = document.querySelector('div.iltext')?.text.trim() ?? '';
  if (response.statusCode == _statusOk) {
    var b64 = RegExp(r'\[.*\]')
        .firstMatch(video_text)
        ?.group(0)
        ?.replaceAll(RegExp(r'[\[\]"]'), '');
    var num = int.tryParse(
        RegExp(r'\)\) - (\d+)').firstMatch(video_text)?.group(1) ?? '');

    if (b64 != null && num != null) {
      details.videoLink = _decode_episode_link(b64, num);
    }
  } else {
    log('Error: Fetch request returned status code ${response.statusCode}');
  }
  return details;
}

Future<ShowDetails> get_show_details(String url) async {
  var details = ShowDetails(url: url);

  final response = await http.get(Uri.parse(server + url));
  if (response.statusCode == _statusOk) {
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
        .map((ep) =>
            EpisodeDetails(title: ep.text.trim(), url: ep.attributes['href']))
        .toList();
  } else {
    log('Error: Fetch request returned status code ${response.statusCode}');
  }
  return details;
}

Future<List<ShowDetails>> get_catalogue(String category) async {
  var show_list = <ShowDetails>[];
  final response = await http.get(Uri.parse(server + category));
  if (response.statusCode == _statusOk) {
    final document = parser.parse(response.body);
    var show_list = document
        .querySelectorAll('div.ddmcc>ul>ul>li>a')
        .map(
          (e) => ShowDetails(
            title: e.text.trim(),
            url: e.attributes['href'] ?? '',
          ),
        )
        .where((e) => e.url != '')
        .toList();
    return show_list;
  } else {
    log('Error: Fetch request returned status code ${response.statusCode}');
  }
  return show_list;
}

Future<List<ShowDetails>> get_popular() async {
  List<ShowDetails> show_details = [];
  final response = await http.get(Uri.parse(server));
  if (response.statusCode == _statusOk) {
    final document = parser.parse(response.body);
    var show_details = document
        .querySelectorAll('ul.items>li')
        .map(
          (e) => ShowDetails(
            title: e.children[1].text.trim(),
            image:
                e.children[0].children[0].children[0].attributes['src'] ?? '',
            url: e.children[0].children[0].attributes['href'] ?? '',
          ),
        )
        .where((e) => e.url != '' && e.image != '')
        .toList();
    return show_details;
  } else {
    log('Error: Fetch request returned status code ${response.statusCode}');
  }
  return [];
}
