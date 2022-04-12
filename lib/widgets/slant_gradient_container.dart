import 'package:flutter/material.dart';
import 'package:anime_tv/utils.dart';

class SlantGradientBackgroundContainer extends StatelessWidget {
  const SlantGradientBackgroundContainer({
    Key? key,
    required this.child,
    this.colors,
  }) : super(key: key);

  final Widget? child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors ??
                [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.darken(),
                ]),
      ),
      child: child,
    );
  }
}
