import 'package:flutter/material.dart';
import 'recent.dart';
import 'catalogue.dart';
import 'package:anime_tv/app_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _navigation_index = 0;

  @override
  void initState() {
    super.initState();
  }

  BottomNavigationBar build_nav_bar(List<Map<String, dynamic>> pages) {
    final items = pages
        .map((x) => BottomNavigationBarItem(
              icon: Icon(x['icon'] as IconData),
              label: x['label'] as String,
              // backgroundColor: _navigation_colors[index]
              backgroundColor: x['accent'],
            ))
        .toList();

    return BottomNavigationBar(
      currentIndex: _navigation_index,
      onTap: (index) => setState(() {
        _navigation_index = index;
      }),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Map<String, dynamic>>[
      {
        'label': 'Recent',
        'icon': Icons.movie,
        'widget': const Recent(),
        'accent': Colors.red,
      },
      {
        'label': 'Catalogue',
        'icon': Icons.video_collection,
        'widget': const CatalogueGroup(),
        'accent': const Color.fromARGB(255, 33, 117, 243),
      },
      {
        'label': 'Search',
        'icon': Icons.search,
        'widget': Text('Search'),
        'accent': const Color.fromARGB(255, 136, 86, 223),
      },
      {
        'label': 'Favorites',
        'icon': Icons.star,
        'widget': Text('Favorites'),
        'accent': const Color.fromARGB(255, 253, 164, 0),
      },
      {
        'label': 'Settings',
        'icon': Icons.settings,
        'widget': Text('Settings'),
        'accent': Colors.green,
      },
    ];

    return Scaffold(
      appBar: get_app_bar(context, pages[_navigation_index]['accent']),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 16, 16, 16),
                Color.fromARGB(255, 53, 53, 53),
              ]),
        ),
        child: IndexedStack(
          index: _navigation_index,
          children: pages.map((x) => x['widget'] as Widget).toList(),
        ),
      ),
      bottomNavigationBar: build_nav_bar(pages),
    );
  }
}
