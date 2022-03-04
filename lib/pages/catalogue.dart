import 'package:anime_tv/pages/show_detail_view.dart';
import 'package:anime_tv/pages/view_episode.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/api.dart';

class CatalogueGroup extends StatefulWidget {
  const CatalogueGroup({Key? key}) : super(key: key);

  @override
  State<CatalogueGroup> createState() => _CatalogueGroupState();
}

class _CatalogueGroupState extends State<CatalogueGroup> {
  var catalogue = <String, List<Map<String, String>>>{};

  @override
  void initState() {
    for (var category in categories.keys) {
      catalogue[category] = <Map<String, String>>[];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 33, 117, 243),
            child: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: categories.keys.map((x) => Tab(text: x)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
                children: categories.keys
                    .map(
                      (x) => Catalogue(
                        category: x,
                        hasEpisodes: x != 'Movies' && x != 'OVAs',
                      ),
                    )
                    .toList()),
          ),
        ],
      ),
    );
  }
}

class Catalogue extends StatefulWidget {
  final String _category;
  final bool _hasEpisodes;

  const Catalogue({Key? key, required category, required hasEpisodes})
      : _category = category,
        _hasEpisodes = hasEpisodes,
        super(key: key);

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue>
    with AutomaticKeepAliveClientMixin<Catalogue> {
  var _catalogue = <ShowDetails>[];
  var _filteredItemsIndices = <int>[];

  TextEditingController searchController = TextEditingController();

  bool load_complete = false;
  bool load_error = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    get_catalogue(categories[widget._category]!).then((value) {
      if (mounted) {
        setState(() {
          _catalogue = value;
          _filteredItemsIndices =
              List<int>.generate(_catalogue.length, (i) => i);
          load_complete = true;
          load_error = false;
        });
      }
    }, onError: (err) {
      if (mounted) {
        setState(() {
          load_error = true;
          load_complete = false;
        });
      }
    });
    super.initState();
  }

  Widget buildListItem(int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 48, 48, 48)),
      onPressed: () {
        final detail = _catalogue[_filteredItemsIndices[index]];
        if (widget._hasEpisodes) {
          if (detail.url != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowDetailPage(url: detail.url!),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEpisode(url: server + detail.url!),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(15),
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
    if (load_error) {
      return const Text("Some Error occured");
    } else if (!load_complete) {
      return const Center(child: CircularProgressIndicator());
    }

    final search_bar = TextField(
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

    final list_view = ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      itemCount: _filteredItemsIndices.length,
      itemBuilder: (context, index) => buildListItem(index),
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
    return Column(
      children: [
        SizedBox(height: 8),
        search_bar,
        SizedBox(height: 8),
        Expanded(child: list_view),
      ],
    );
  }
}
