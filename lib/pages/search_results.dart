import 'package:anime_tv/widgets/app_bar.dart';
import 'package:anime_tv/widgets/search_results.dart';
import 'package:anime_tv/widgets/slant_gradient_container.dart';
import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;
  const SearchResultsPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimeTVAppBar(),
      body: SlantGradientBackgroundContainer(
        child: SearchResultsView(query: query),
      ),
    );
  }
}
