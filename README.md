<p align="center">
    <img src="https://raw.githubusercontent.com/GnikDroy/AnimeTV/master/assets/icon.png">

<h1 align="center">Anime TV!</h1>
    
<h3 align="center"> Watch your favorite anime on your device </h3>

Anime TV! is a cross-platform app that allows you to watch your favorite anime shows on your device. Supports all platforms supported by flutter except for web (impossible due to CORS) i.e Android, IOS, macOS, Linux and Windows. Officially tested in Android and Windows but should work in all platforms.

It has a low memory footprint, stores all information on your device and works off the ~~[Anime1](http://www.anime1.com/)~~ [Wcostream](https://www.wcostream.com/) server. The app scrapes the site and provides a pleasant
anime viewing experience. Unlike other apps, this does not contain any ads and is distributed for free.
Currently, this app is not available in the app store but you can build your apk file and install on your device.

 <img src="https://i.postimg.cc/mZ0X1RSG/flutter-01.jpg" width="400">  <img src="https://i.postimg.cc/x1Q6gR7x/flutter-02.jpg" width="400" align="right">   
 
 ***
 
 <img src="https://i.postimg.cc/QMx0ZMjc/flutter-03.jpg" width="400">   <img src="https://i.postimg.cc/rw9QH428/flutter-04.jpg" width="400" align="right">

 
 ![screenshot](https://i.postimg.cc/k51wJd5z/flutter-05.jpg)

<!-- [url=https://postimg.cc/Sjf7HB5Z][img]https://i.postimg.cc/Sjf7HB5Z/flutter-01.jpg[/img][/url]

[url=https://postimg.cc/PP6b5mdY][img]https://i.postimg.cc/PP6b5mdY/flutter-02.jpg[/img][/url]

[url=https://postimg.cc/HrRQQdcL][img]https://i.postimg.cc/HrRQQdcL/flutter-03.jpg[/img][/url]

[url=https://postimg.cc/sMvYQv28][img]https://i.postimg.cc/sMvYQv28/flutter-04.jpg[/img][/url]

[url=https://postimg.cc/4KcpPqVQ][img]https://i.postimg.cc/4KcpPqVQ/flutter-05.jpg[/img][/url] -->

## Setting up

Make sure you have flutter installed on your device, along with the necessary SDKs for your platform.

If you decide to change the app name, icon, or both, make sure to run the following commands.

```sh
flutter pub run flutter_app_name
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

## Build the apk

```sh

flutter build
```

## Running Tests

```sh
flutter test
```

Currently, only the scraper has unit tests. If you would like to write the tests for, start an issue. Please make sure the tests are meaningful! I do not want to over-engineer a volatile app (I obviously don't own the server).

## Contributing

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

1. Fork it (<https://github.com/GnikDroy/AnimeTV/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

Gnik - gnikdroy@gmail.com

Distributed under a MIT license. See ``LICENSE`` for more information.
