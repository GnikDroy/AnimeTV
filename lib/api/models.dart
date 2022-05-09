class Category {
  final String title;
  final String url;
  const Category(this.title, this.url);
}

class ShowDetails {
  String? title;
  String? url;
  String? image;
  String? description;
  List<EpisodeDetails>? episodeList;
  List<String>? genreList;

  ShowDetails({
    this.title,
    this.url,
    this.image,
    this.description,
    this.episodeList,
    this.genreList,
  });

  static ShowDetails fromMap(Map<String, String?> show) {
    return ShowDetails(
      title: show["title"],
      description: show['description'],
      image: show['image'],
      url: show['url'],
    );
  }

  Map<String, String?> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'url': url,
    };
  }
}

class StreamUrls {
  final List<String> sd = [];
  final List<String> hd = [];
}

class EpisodeDetails {
  String? url;
  String? title;
  StreamUrls streamUrls;

  bool hasStreams() {
    return streamUrls.hd.isNotEmpty || streamUrls.sd.isNotEmpty;
  }

  Map<String, String> getResolutions() {
    var ret = <String, String>{};
    for (int i = 0; i < streamUrls.hd.length; i++) {
      if (i == 0) {
        ret['720p'] = streamUrls.hd[i];
      } else {
        ret['720p_${i}'] = streamUrls.hd[i];
      }
    }
    for (int i = 0; i < streamUrls.sd.length; i++) {
      if (i == 0) {
        ret['360p'] = streamUrls.sd[i];
      } else {
        ret['360p_${i}'] = streamUrls.sd[i];
      }
    }
    return ret;
  }

  String? getAnyStream() {
    if (streamUrls.hd.isNotEmpty) {
      return streamUrls.hd.first;
    }
    if (streamUrls.sd.isNotEmpty) {
      return streamUrls.sd.first;
    }
    return null;
  }

  EpisodeDetails({this.url, this.title, required this.streamUrls});
}

class RecentEpisode {
  String? image;
  EpisodeDetails episode;
  RecentEpisode({this.image, required this.episode});
}

const categories = <Category>[
  Category('Subbed', '/subbed-anime-list'),
  Category('Dubbed', '/dubbed-anime-list'),
  Category('Cartoons', '/cartoon-list'),
  Category('Movies', '/movie-list'),
  Category('OVAs', '/ova-list'),
];
