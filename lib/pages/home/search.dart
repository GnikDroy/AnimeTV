import 'package:anime_tv/routes.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();

  bool searching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const poster = SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image(
        image: AssetImage('assets/poster.jpg'),
        fit: BoxFit.cover,
      ),
    );

    final overlay = Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black.withOpacity(0.8),
    );

    final searchBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: searchController,
        onSubmitted: (query) {
          Navigator.pushNamed(context, SearchResultsRoute.routeName,
              arguments: query);
        },
        decoration: const InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );

    final stack = Stack(
      alignment: Alignment.center,
      children: [
        poster,
        overlay,
        searchBar,
      ],
    );

    return stack;
  }
}
