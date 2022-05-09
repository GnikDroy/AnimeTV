import 'package:anime_tv/routes.dart';
import 'package:anime_tv/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api/api.dart';
import 'package:anime_tv/api/models.dart';

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
  var _catalogue = <Show>[];
  var _filteredItemsIndices = <int>[];

  TextEditingController searchController = TextEditingController();

  bool loadComplete = false;
  bool loadError = false;

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
    return Api.getCatalogue(widget._category.url).then((value) {
      setState(() {
        _catalogue = value;
        _filteredItemsIndices = List<int>.generate(_catalogue.length, (i) => i);
        loadComplete = true;
        loadError = false;
      });
    }, onError: (err) {
      setState(() {
        loadError = true;
        loadComplete = false;
      });
    });
  }

  Widget buildListItem(int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        final detail = _catalogue[_filteredItemsIndices[index]];
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
          _catalogue[_filteredItemsIndices[index]].title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void filterResults(String query) {
    query = query.toLowerCase();
    _filteredItemsIndices.clear();
    _catalogue.asMap().forEach((k, v) {
      if (v.title.toLowerCase().contains(query)) {
        _filteredItemsIndices.add(k);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loadError) {
      return genericNetworkError;
    } else if (!loadComplete) {
      return const Center(child: CircularProgressIndicator());
    }

    final searchBar = TextField(
      controller: searchController,
      onChanged: filterResults,
      decoration: const InputDecoration(
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

    final listView = RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(5),
        itemCount: _filteredItemsIndices.length,
        itemBuilder: (context, index) => buildListItem(index),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );

    super.build(context);
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
  }
}
