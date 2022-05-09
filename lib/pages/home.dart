import 'package:anime_tv/pages/home/favorite_shows.dart';
import 'package:anime_tv/pages/home/search.dart';
import 'package:anime_tv/widgets/slant_gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/pages/home/recent_episodes.dart';
import 'package:anime_tv/pages/home/catalogue_group.dart';
import 'package:anime_tv/widgets/app_bar.dart';

class HomeSubPage {
  final String label;
  final IconData icon;
  final Widget widget;
  final Color accent;

  const HomeSubPage(
      {required this.label,
      required this.icon,
      required this.widget,
      required this.accent});
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _navigationIdx = 0;

  @override
  void initState() {
    super.initState();
  }

  BottomNavigationBar buildNavBar(List<HomeSubPage> pages) {
    final items = pages
        .map((x) => BottomNavigationBarItem(
              icon: Icon(x.icon),
              label: x.label,
              backgroundColor: x.accent,
            ))
        .toList();

    return BottomNavigationBar(
      currentIndex: _navigationIdx,
      onTap: (index) => setState(() {
        _navigationIdx = index;
      }),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    const pages = [
      HomeSubPage(
        label: 'Recent',
        icon: Icons.movie,
        widget: RecentEpisodesGrid(),
        accent: Color.fromARGB(255, 191, 63, 54),
      ),
      HomeSubPage(
        label: 'Catalogue',
        icon: Icons.video_collection,
        accent: Color.fromARGB(255, 20, 148, 131),
        widget: CatalogueGroup(
          tabBarColor: Color.fromARGB(255, 20, 148, 131),
        ),
      ),
      HomeSubPage(
        label: 'Search',
        icon: Icons.search,
        widget: SearchView(),
        accent: Color.fromARGB(255, 136, 86, 223),
      ),
      HomeSubPage(
        label: 'Favorites',
        icon: Icons.star,
        widget: FavoriteShowsView(),
        accent: Color.fromARGB(255, 206, 137, 9),
      ),
    ];

    final scaffold = Scaffold(
      appBar: AnimeTVAppBar(borderColor: pages[_navigationIdx].accent),
      body: SlantGradientBackgroundContainer(
        child: IndexedStack(
          index: _navigationIdx,
          children: pages.map((x) => x.widget).toList(),
        ),
      ),
      bottomNavigationBar: buildNavBar(pages),
    );

    return GestureDetector(
      onTapDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      child: scaffold,
    );
  }
}
