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
    final url = episodes[0].url;
    expect(url.isNotEmpty, true);
    expect(episodes[0].cover.isNotEmpty, true);
  });

  test('Get Episode Details', () async {
    final results = await Api.getEpisodeDetails(
        'https://www.wcostream.com/bleach-episode-360-english-subbed');

    expect(results.title.isNotEmpty, true);
    expect(results.url.isNotEmpty, true);
    expect(results.next.isNotEmpty, true);
    expect(results.prev.isNotEmpty, true);
    expect(
        results.videoSource.sd.isNotEmpty || results.videoSource.hd.isNotEmpty,
        true);
  });

  test('Fetch catalogue and show details', () async {
    final catalogue = await Api.getCatalogue(categories[0].url);
    expect(catalogue.isNotEmpty, true);
    expect(catalogue[0].url.isNotEmpty, true);
    expect(catalogue[0].title.isNotEmpty, true);

    final showDetails = await Api.getShowDetails(catalogue[0].url);
    expect(showDetails.image.isNotEmpty, true);
    expect(showDetails.episodeList.isNotEmpty, true);
    expect(showDetails.description.isNotEmpty, true);
  });

  test('Search show.', () async {
    final results = await Api.searchShow('bleach');
    expect(results.isNotEmpty, true);
    expect(results[0].url.isNotEmpty, true);
    expect(results[0].title.isNotEmpty, true);
    expect(results[0].image.isNotEmpty, true);
  });
}
