<p align="center">
    <img src="https://raw.githubusercontent.com/GnikDroy/AnimeTV/master/app/src/main/res/mipmap-xxhdpi/ic_launcher.png">

<h1 align="center">Anime TV!</h1>
    
<h3 align="center"> Watch your favorite anime on your android device </h3>

<img src="https://www.codefactor.io/repository/github/gnikdroy/animetv/badge">&nbsp;<img src="https://img.shields.io/github/license/mashape/apistatus.svg">
</p>


Anime TV! is a small app that allows you to watch your favorite anime shows on your android device.


It has a very low memory footprint and works off the [Anime1](http://www.anime1.com/) server. The app scrapes the site and provides a pleasant
mobile anime viewing experience. Unlike other apps, this does not contain any ads and is distributed for free.
Currently, this app is not available in the app store but you can build your apk file and install on your device. 
 
 
 <img src="https://raw.githubusercontent.com/GnikDroy/AnimeTV/screenshots/screenshots/1.png" width="400">  <img src="https://raw.githubusercontent.com/GnikDroy/AnimeTV/screenshots/screenshots/2.png" width="400" align="right">   
 
 ***
 
 <img src="https://raw.githubusercontent.com/GnikDroy/AnimeTV/screenshots/screenshots/3.png" width="400">   <img src="https://raw.githubusercontent.com/GnikDroy/AnimeTV/screenshots/screenshots/5.png" width="400" align="right">
 
 ![screenshot](https://raw.githubusercontent.com/GnikDroy/AnimeTV/screenshots/screenshots/4.png)
 ![screenshot](https://raw.githubusercontent.com/GnikDroy/AnimeTV/screenshots/screenshots/6.png)

## Installation

You need to have gradle installed in order to install the app

OS X & Linux:

`./gradlew assembleRelease`

Windows:

`gradlew.bat assembleRelease`

The output apk will be in `/app/build/outputs/apk/release`.
Transfer the apk to your device and install it to use the application. 

## Running Tests

In order to run tests you need to have gradle installed.

OS X & Linux:

`./gradlew test`

Windows:

`gradlew.bat test`

Currently, only the scraper package has got unit tests. If you would like to write the unit tests for the animetv package, start an issue.

## Contributing

1. Fork it (<https://github.com/GnikDroy/AnimeTV/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

Gnik - gnikdroy@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

