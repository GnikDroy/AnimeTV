import 'package:flutter/material.dart';
import 'package:anime_tv/api/models.dart';
import 'package:anime_tv/widgets/catalogue.dart';

class CatalogueGroup extends StatelessWidget {
  final Color tabBarColor;
  const CatalogueGroup({Key? key, required this.tabBarColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            color: tabBarColor,
            child: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: categories.map((x) => Tab(text: x.title)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
                children: categories
                    .map(
                      (x) => Catalogue(
                        category: x,
                      ),
                    )
                    .toList()),
          ),
        ],
      ),
    );
  }
}
