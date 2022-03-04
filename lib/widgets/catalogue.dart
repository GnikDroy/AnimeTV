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
  var _catalogue = <ShowDetails>[];
  var _filteredItemsIndices = <int>[];

  TextEditingController searchController = TextEditingController();

  bool loadComplete = false;
  bool loadError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    get_catalogue(widget._category.url).then((value) {
      if (mounted) {
        setState(() {
          _catalogue = value;
          _filteredItemsIndices =
              List<int>.generate(_catalogue.length, (i) => i);
          loadComplete = true;
          loadError = false;
        });
      }
    }, onError: (err) {
      if (mounted) {
        setState(() {
          loadError = true;
          loadComplete = false;
        });
      }
    });
    super.initState();
  }

  Widget buildListItem(int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        final detail = _catalogue[_filteredItemsIndices[index]];
        if (widget._hasEpisodes) {
          if (detail.url != null) {
            Navigator.pushNamed(
              context,
              ShowDetailRoute.routeName,
              arguments: detail.url!,
            );
          }
        } else {
          Navigator.pushNamed(
            context,
            ViewEpisodeRoute.routeName,
            arguments: server + detail.url!,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          _catalogue[_filteredItemsIndices[index]].title!,
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
    final data = _catalogue.asMap().forEach((k, v) {
      if (v.title!.toLowerCase().contains(query)) {
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
        labelText: "Search",
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

    final listView = ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      itemCount: _filteredItemsIndices.length,
      itemBuilder: (context, index) => buildListItem(index),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );

    super.build(context);
    return Column(
      children: [
        const SizedBox(height: 8),
        searchBar,
        const SizedBox(height: 8),
        Expanded(child: listView),
      ],
    );
  }
}
