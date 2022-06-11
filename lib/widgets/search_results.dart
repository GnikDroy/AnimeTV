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
  late Future<List<Show>> searchResults;
  static const double cardHeight = 400;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  Future<void> onRefresh() {
    setState(() {
      searchResults = Api.searchShow(widget.query);
    });
    return searchResults;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: searchResults,
        builder: (context, AsyncSnapshot<List<Show>> snapshot) {
          if (snapshot.hasData) {
            final shows = snapshot.data!;
            var widgets = <Widget>[];
            for (final show in shows) {
              final image = (show.image.isEmpty
                  ? const AssetImage('assets/cover_placeholder.jpg')
                  : NetworkImage(show.image)) as ImageProvider;

              widgets.add(
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ShowDetailRoute.routeName,
                      arguments: show.url,
                    );
                  },
                  child: ImageCard(
                    title: show.title,
                    image: image,
                    height: cardHeight,
                  ),
                ),
              );
            }

            const double extent = 300;
            final gridView = GridView.builder(
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
            );

            return RefreshIndicator(
              onRefresh: onRefresh,
              child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  "${widgets.length} results for '${widget.query}'",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: gridView),
              ]),
            );
          } else if (snapshot.hasError) {
            return genericNetworkError;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
