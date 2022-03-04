class Category {
  final String title;
  final String url;
  const Category(this.title, this.url);
}

class EpisodeDetails {
  String? url;
  String? title;
  String? videoLink;
  EpisodeDetails({this.url, this.title, this.videoLink});
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
}

const categories = <Category>[
  Category('Subbed', '/subbed-anime-list'),
  Category('Dubbed', '/dubbed-anime-list'),
  Category('Cartoons', '/cartoon-list'),
  Category('Movies', '/movie-list'),
  Category('OVAs', '/ova-list'),
];
