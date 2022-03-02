import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer';
import 'dart:convert';

void main() {
  runApp(const AnimeTV());
}

class AnimeTV extends StatelessWidget {
  const AnimeTV({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  Future<String> decode_episode_link(String b64, int num) async {
    final js = b64
        .split(',')
        .map((x) => x.trim())
        .map(base64.decoder.convert)
        .map(utf8.decode)
        .map((x) => x.replaceAll(new RegExp(r'[^0-9]'), ''))
        .map(int.parse)
        .map((x) => (x - num))
        .map(String.fromCharCode)
        .join('');
    final url = RegExp(r'src="(.*?)"').firstMatch(js)?.group(1);
    final server = 'https://www.wcostream.com';

    const statusOk = 200;

    if (url != null) {
      print(server + url);
      // final response = await http.get(Uri.parse(server + url));
      // if (response.statusCode == statusOk) {
      //   final apiUrl =
      //       RegExp(r'get\("(.*?)"\)').firstMatch(response.body)?.group(1);
      //   if (apiUrl != null) {
      // final api_response =
      // await http.get(Uri.parse(server + apiUrl), headers: {
      // 'X-Requested-With': 'XMLHttpRequest',
      // });
      // final api_response_json =
      // jsonDecode(utf8.decode(api_response.bodyBytes)) as Map;

      // var quality = api_response_json.containsKey('hd') &&
      // api_response_json['hd'] != null
      // ? 'hd'
      // : 'enc';
      // print(quality);
      // print(api_response_json['server']);
      // print(api_response_json[quality]);
      // final vid_link =
      // "${api_response_json['server']}/getvid?evid=${api_response_json[quality]}";
      // print(vid_link);
      //   }
      // } else {
      //   log('Error: Fetch request returned status code ${response.statusCode}');
      // }
    }
    return '';
  }

  Future<Map> episode_details(String url) async {
    Map details = {};
    const statusOk = 200;

    final response = await http.get(Uri.parse(url));
    final document = parser.parse(response.body);
    final video_text = document.querySelector('div.iltext')?.text.trim() ?? '';
    if (response.statusCode == statusOk) {
      var b64 = RegExp(r'\[.*\]')
          .firstMatch(video_text)
          ?.group(0)
          ?.replaceAll(RegExp(r'[\[\]"]'), '');
      var num = int.tryParse(
          RegExp(r'\)\) - (\d+)').firstMatch(video_text)?.group(1) ?? '');

      if (b64 != null && num != null) {
        decode_episode_link(b64, num);
      }
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return details;
  }

  Future<Map> get_details(String url) async {
    var details = {};
    final server = 'https://www.wcostream.com';
    const statusOk = 200;

    final response = await http.get(Uri.parse(server + url));
    if (response.statusCode == statusOk) {
      final document = parser.parse(response.body);
      details['image'] =
          document.querySelector('div#cat-img-desc>div>img')?.attributes['src'];

      details['description'] =
          document.querySelector('div#cat-img-desc>.iltext')?.text.trim();

      details['genres'] = document
          .querySelectorAll('div#cat-genre>.wcobtn>a')
          .map((g) => {g.text.trim()});

      details['episodes'] = document
          .querySelectorAll('div#catlist-listview>ul>li>a')
          .map((ep) => [ep.text.trim(), ep.attributes['href']])
          .toList();

      episode_details(details['episodes'][0][1]);
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return details;
  }

  Future<List<Map>> popular() async {
    List<Map> anime_details = [];
    final endpoint = 'https://www.wcostream.com';
    const statusOk = 200;

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == statusOk) {
      final document = parser.parse(response.body);
      var anime_details = document
          .querySelectorAll('div.menustyle>ul>li>a')
          .map((e) => {'name': e.text.trim(), 'url': e.attributes['href']})
          .toList();

      var test_url = anime_details[0]['url'];
      if (test_url != null) {
        print(await get_details(test_url));
      }
    } else {
      log('Error: Fetch request returned status code ${response.statusCode}');
    }
    return [];
  }

  void _incrementCounter() {
    popular();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const WebView(
              initialUrl:
                  'https://www.wcostream.com/inc/cizgifilmlerizle/embed.php?file=Blade%20Runner%20Black%20Lotus%20Dubbed%2FWatch%20Blade%20Runner-%20Black%20Lotus%20%28Dub%29%20Episode%2013.flv&hd=1&pid=603630&h=e07163a4f853203fd94af13f7539c8a8&t=1646215230&subd=ndisk',
              javascriptMode: JavascriptMode.unrestricted,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
