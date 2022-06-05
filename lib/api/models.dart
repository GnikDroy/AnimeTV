class Category {
  final String title;
  final String url;
  const Category(this.title, this.url);
}

class Show {
  String title;
  String url;
  String image;
  String description;
  List<Episode> episodeList;
  List<String> genreList;

  Show({
    this.title = '',
    this.url = '',
    this.image = '',
    this.description = '',
    this.episodeList = const [],
    this.genreList = const [],
  });

  static Show fromMap(Map<String, String> show) {
    return Show(
      title: show["title"] ?? '',
      description: show['description'] ?? '',
      image: show['image'] ?? '',
      url: show['url'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'url': url,
    };
  }
}

class VideoSource {
  List<String> sd;
  List<String> hd;
  VideoSource({hd, sd})
      : hd = hd ?? [],
        sd = sd ?? [];
}

class Episode {
  String url;
  String title;
  String prev;
  String next;
  VideoSource videoSource = VideoSource();

  bool hasVideoSource() {
    return videoSource.hd.isNotEmpty || videoSource.sd.isNotEmpty;
  }

  Map<String, String> getVideoResolutions() {
    var ret = <String, String>{};
    for (int i = 0; i < videoSource.hd.length; i++) {
      if (i == 0) {
        ret['1080p'] = videoSource.hd[i];
      } else {
        ret['1080p_$i'] = videoSource.hd[i];
      }
    }
    for (int i = 0; i < videoSource.sd.length; i++) {
      if (i == 0) {
        ret['480p'] = videoSource.sd[i];
      } else {
        ret['480p_$i'] = videoSource.sd[i];
      }
    }
    return ret;
  }

  String getSingleVideoSource() {
    if (videoSource.hd.isNotEmpty) {
      return videoSource.hd.first;
    }
    if (videoSource.sd.isNotEmpty) {
      return videoSource.sd.first;
    }
    return '';
  }

  Episode({this.url = '', this.title = '', this.prev = '', this.next = ''});
}

class RecentEpisode {
  String url;
  String title;
  String cover;
  RecentEpisode({required this.url, required this.title, required this.cover});
}

const categories = <Category>[
  Category('Subbed', '/subbed-anime-list'),
  Category('Dubbed', '/dubbed-anime-list'),
  Category('Cartoons', '/cartoon-list'),
  Category('Movies', '/movie-list'),
  Category('OVAs', '/ova-list'),
];
