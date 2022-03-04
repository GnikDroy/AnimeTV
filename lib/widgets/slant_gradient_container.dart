import 'package:flutter/material.dart';

class SlantGradientBackgroundContainer extends StatelessWidget {
  const SlantGradientBackgroundContainer({
    Key? key,
    required this.child,
    this.colors = const [
      Color.fromARGB(255, 18, 20, 36),
      Color.fromARGB(255, 33, 36, 59),
    ],
  }) : super(key: key);

  final Widget? child;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors),
      ),
      child: child,
    );
  }
}
