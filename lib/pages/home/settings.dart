import 'dart:io';

import 'package:anime_tv/widgets/slant_gradient_container.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final Color accent;
  const SettingsView({
    Key? key,
    required this.accent,
  }) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final about = SlantGradientBackgroundContainer(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: const [
          Icon(Icons.live_tv_outlined, size: 80, color: Colors.deepOrange),
          SizedBox(height: 15),
          Text(
            "Watch Your Favorite Shows",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            "Anywhere, Anytime",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 15),
          Text("Version: 1.0.3"),
        ]),
      ),
      colors: [
        widget.accent.withOpacity(0.5),
        widget.accent,
      ],
    );
    final settings = Container();
    return ListView(children: [about, settings]);
  }
}
