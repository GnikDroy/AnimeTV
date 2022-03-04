import 'package:flutter/material.dart';

class AnimeTVAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  const AnimeTVAppBar({
    Key? key,
    this.title = 'Anime TV',
    this.color = const Color.fromARGB(230, 255, 255, 255),
    this.backgroundColor = const Color.fromARGB(255, 24, 24, 24),
    this.borderColor = Colors.white,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var titleWidgets = <Widget>[];

    if (!(ModalRoute.of(context)?.canPop ?? false)) {
      titleWidgets.add(
        Icon(
          Icons.live_tv_outlined,
          size: 35,
          color: color,
        ),
      );
      titleWidgets.add(const SizedBox(width: 15));
    }

    titleWidgets.add(Text(
      this.title,
      style: TextStyle(
        color: color,
      ),
    ));

    final title = Row(
      children: titleWidgets,
    );
    return AppBar(
      shape: Border(
        bottom: BorderSide(
          color: borderColor,
        ),
      ),
      elevation: 0,
      backgroundColor: backgroundColor,
      title: title,
    );
  }
}
