import 'package:flutter/material.dart';

import 'package:skeleton_text/skeleton_text.dart';

import 'package:anime_tv/routes.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/utils.dart';

class Catalogue extends StatefulWidget {
  final Category _category;
  final bool _hasEpisodes;

  Catalogue({
    Key? key,
    required Category category,
  })  : _category = category,
        _hasEpisodes = (category.title != 'Movies' && category.title != 'OVAs'),
        super(key: key);

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue>
    with AutomaticKeepAliveClientMixin<Catalogue> {
  late Future<List<Show>> _catalogue;
  var _filteredItemsIndices = <int>[];

  TextEditingController searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

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
      _catalogue = () async {
        final catalogue = await Api.getCatalogue(widget._category.url);
        _filteredItemsIndices =
            List<int>.generate(catalogue.length, (i) => (i));
        return catalogue;
      }();
    });
    return _catalogue;
  }

  Widget buildListItem(int index, List<Show> catalogue) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        final detail = catalogue[_filteredItemsIndices[index]];
        if (widget._hasEpisodes) {
          if (detail.url.isNotEmpty) {
            Navigator.pushNamed(
              context,
              ShowDetailRoute.routeName,
              arguments: detail.url,
            );
          }
        } else {
          Navigator.pushNamed(
            context,
            ViewEpisodeRoute.routeName,
            arguments: Api.server + detail.url,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          catalogue[_filteredItemsIndices[index]].title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void filterResults(String query, List<Show> catalogue) {
    query = query.toLowerCase();
    _filteredItemsIndices.clear();
    catalogue.asMap().forEach((k, v) {
      if (v.title.toLowerCase().contains(query)) {
        _filteredItemsIndices.add(k);
      }
    });
    setState(() {});
  }

  Widget buildSkeleton(BuildContext context) {
    const searchSkeleton = TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
      ),
    );

    final itemSkeleton = SkeletonAnimation(
      shimmerColor: Theme.of(context).backgroundColor,
      shimmerDuration: 800,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.lighten(),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final listSkeleton = ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(5),
      itemCount: 12,
      itemBuilder: (context, index) => SizedBox(
        child: itemSkeleton,
        height: 40,
        width: double.infinity,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );

    return Column(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: searchSkeleton,
        ),
        const SizedBox(height: 8),
        Expanded(child: listSkeleton),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _catalogue,
      builder: (context, AsyncSnapshot<List<Show>> snapshot) {
        if (snapshot.hasData) {
          final searchBar = TextField(
            controller: searchController,
            onChanged: (x) => filterResults(x, snapshot.data!),
            decoration: const InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
          );

          final listView = RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(5),
              itemCount: _filteredItemsIndices.length,
              itemBuilder: (context, index) =>
                  buildListItem(index, snapshot.data!),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );

          return Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: searchBar,
              ),
              const SizedBox(height: 8),
              Expanded(child: listView),
            ],
          );
        } else if (snapshot.hasError) {
          return genericNetworkError;
        } else {
          return buildSkeleton(context);
        }
      },
    );
  }
}
