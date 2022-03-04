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
  var searchResults = <ShowDetails>[];
  static const double cardHeight = 400;
  bool loadComplete = false;
  bool loadError = false;

  @override
  void initState() {
    assert(widget.query.isNotEmpty);
    searchShow(widget.query).then((shows) {
      if (mounted) {
        setState(() {
          searchResults = shows;
          loadComplete = true;
          loadError = false;
        });
      }
    }, onError: (err) {
      if (mounted) {
        setState(() {
          loadComplete = false;
          loadError = true;
        });
      }
    });
    super.initState();
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
      final image = (details.image == null
          ? const AssetImage('assets/cover_placeholder.jpg')
          : NetworkImage(details.image!)) as ImageProvider;

      final title = details.title ?? '';
      widgets.add(
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ShowDetailRoute.routeName,
              arguments: details.url!,
            );
          },
          child: ImageCard(title: title, image: image, height: cardHeight),
        ),
      );
    }

    const double extent = 300;
    return GridView.builder(
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
  }
}
