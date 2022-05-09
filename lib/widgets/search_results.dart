import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/routes.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:anime_tv/widgets/image_card.dart';
import 'package:flutter/material.dart';

class SearchResultsView extends StatefulWidget {
  final String query;
  const SearchResultsView({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  var searchResults = <Show>[];
  static const double cardHeight = 400;
  bool loadComplete = false;
  bool loadError = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    assert(widget.query.isNotEmpty);
    onRefresh();
    super.initState();
  }

  Future<void> onRefresh() {
    return Api.searchShow(widget.query).then((shows) {
      setState(() {
        searchResults = shows;
        loadComplete = true;
        loadError = false;
      });
    }, onError: (err) {
      setState(() {
        loadComplete = false;
        loadError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadError) {
      return genericNetworkError;
    } else if (!loadComplete) {
      return const Center(child: CircularProgressIndicator());
    }

    var widgets = <Widget>[];
    for (final details in searchResults) {
      final image = (details.image.isEmpty
          ? const AssetImage('assets/cover_placeholder.jpg')
          : NetworkImage(details.image)) as ImageProvider;

      widgets.add(
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ShowDetailRoute.routeName,
              arguments: details.url,
            );
          },
          child:
              ImageCard(title: details.title, image: image, height: cardHeight),
        ),
      );
    }

    const double extent = 300;
    final ret = Column(children: [
      const SizedBox(height: 10),
      Text(
        "${widgets.length} results for '${widget.query}'",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: GridView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: extent,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: extent / (cardHeight),
          ),
          itemBuilder: (_, index) => widgets[index],
          itemCount: widgets.length,
        ),
      ),
    ]);

    return RefreshIndicator(onRefresh: onRefresh, child: ret);
  }
}
