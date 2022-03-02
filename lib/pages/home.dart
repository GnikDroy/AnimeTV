import 'package:flutter/material.dart';
import 'popular.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var details = {
    'title': 'Bleach Subbed With Very long titles',
    'image': '//cdn.animationexplore.com/catimg/50143.jpg',
    'description':
        'High school student Kurosaki Ichigo is unlike any ordinary kid. Why? Because he can see ghosts. Ever since a young age, he’s been able to see spirits from the afterlife. Ichigo’s life completely changes one day when he and his two sisters are attacked by an evil, hungry and tormented spirit known as a Hollow. Right in the nick of time, Ichigo and his siblings are aided by a Shinigami (Death God) named Kuchiki Rukia, whose responsibility it is to send good spirits (Pluses) to the afterlife known as Soul Society, and to purify Hollows and send them up to Soul Society. But during the fight against the Hollow, Rukia is injured and must transfer her powers to Ichigo. With this newly acquired power, so begins Kurosaki Ichigo’s training and duty as a Shinigami to maintain the balance between the world of the living and the world of the dead…',
    'genres': ['Action', 'Comedy', 'Shounen', 'Supernatural'],
  };

  int _navigation_index = 0;

  final _navigation_colors = [
    Colors.red,
    Color.fromARGB(255, 33, 117, 243),
    Color.fromARGB(255, 136, 86, 223),
    Color.fromARGB(255, 253, 164, 0),
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final app_bar = AppBar(
      shape: Border(
          bottom: BorderSide(
        color: _navigation_colors[_navigation_index],
        width: 1,
      )),
      leading: const Icon(
        Icons.live_tv_outlined,
        size: 35,
        color: Color.fromARGB(230, 255, 255, 255),
      ),
      title: const Text(
        'Anime TV',
        style: TextStyle(
          color: Color.fromARGB(230, 255, 255, 255),
        ),
      ),
      elevation: 0,
      backgroundColor: const Color(0x44000000),
    );

    final nav_bar = BottomNavigationBar(
      currentIndex: _navigation_index,
      onTap: (index) => setState(() {
        _navigation_index = index;
      }),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.movie),
          label: 'Popular',
          backgroundColor: _navigation_colors[0],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.video_collection),
          label: 'Catalogue',
          backgroundColor: _navigation_colors[1],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: 'Search',
          backgroundColor: _navigation_colors[2],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.star),
          label: 'Favorites',
          backgroundColor: _navigation_colors[3],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: _navigation_colors[4],
        ),
      ],
    );

    final List<Widget> pages = [
      const Popular(),
      Text("Catalogue"),
      Text("Search"),
      Text("Favorites"),
      Text("Settings"),
    ];

    return Scaffold(
      appBar: app_bar,
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
          children: pages,
        ),
      ),
      bottomNavigationBar: nav_bar,
    );
  }
}
