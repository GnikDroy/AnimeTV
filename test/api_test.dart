import 'dart:convert';

import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Is "${Api.server}" accessible?', () async {
    final response = await http.get(Uri.parse(Api.server));
    expect(response.statusCode, Api.statusOk);
  });

  test('Fetch recent episodes and video url', () async {
    final episodes = await Api.getRecentEpisodes();
    expect(episodes.isNotEmpty, true);
    final url = episodes[0].episode.url;
    expect(url != null && url.isNotEmpty, true);
    expect(episodes[0].image != null && episodes[0].image!.isNotEmpty, true);
  });

  test('Get StreamURLs', () async {
    const videoLink =
        "https://www.wcostream.com/inc/animeuploads/embed.php?file=Bleach%20English%20Subbed%2FMovies%2FBleach%20Movie%2003%20-%20Fade%20to%20Black.flv&pid=208947&h=9b49a727785aee25c867dd9831dee73d&t=1652033942";
    final json_url = await Api.getJsonApiLink(videoLink);
    expect(json_url != null, true);
    final streamUrls = await Api.getStreamUrls(json_url!);
    expect(streamUrls.sd.isNotEmpty || streamUrls.hd.isNotEmpty, true);
  });

  test('Get Episode Details', () async {
    final results = await Api.getEpisodeDetails(
        'https://www.wcostream.com/bleach-movie-3-fade-to-black-english-subbed');
    expect(results.title != null && results.title!.isNotEmpty, true);
    expect(results.url != null && results.url!.isNotEmpty, true);
    expect(results.streamUrls.sd.isNotEmpty || results.streamUrls.hd.isNotEmpty,
        true);
  });

  test('Fetch catalogue and show details', () async {
    final catalogue = await Api.getCatalogue(categories[0].url);
    expect(catalogue.isNotEmpty, true);
    expect(catalogue[0].url != null && catalogue[0].url!.isNotEmpty, true);
    expect(catalogue[0].title != null && catalogue[0].title!.isNotEmpty, true);

    final showDetails = await Api.getShowDetails(catalogue[0].url!);
    expect(showDetails.image != null, true);
    expect(showDetails.episodeList != null, true);
    expect(showDetails.description != null, true);
  });

  test('Search show.', () async {
    final results = await Api.searchShow('bleach');
    expect(results.isNotEmpty, true);
    expect(results[0].url != null && results[0].url!.isNotEmpty, true);
    expect(results[0].title != null && results[0].title!.isNotEmpty, true);
    expect(results[0].image != null && results[0].image!.isNotEmpty, true);
  });
}
