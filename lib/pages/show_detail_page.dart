import 'package:anime_tv/widgets/slant_gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv/widgets/app_bar.dart';
import 'package:anime_tv/widgets/show_detail.dart';

class ShowDetailPage extends StatelessWidget {
  final String url;
  const ShowDetailPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimeTVAppBar(),
      body: SlantGradientBackgroundContainer(
        child: ShowDetailView(url: url),
      ),
    );
  }
}
