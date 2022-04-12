import 'package:flutter/material.dart';

class AnimeTVAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? borderColor;

  const AnimeTVAppBar({
    Key? key,
    this.title = 'Anime TV',
    this.borderColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var titleWidgets = <Widget>[];

    if (!(ModalRoute.of(context)?.canPop ?? false)) {
      titleWidgets.add(
        Image.asset(
          'assets/icon.png',
          fit: BoxFit.fitHeight,
          height: 50,
        ),
        // size: 35,
      );
      titleWidgets.add(const SizedBox(width: 15));
    }

    titleWidgets.add(Text(
      this.title,
    ));

    final title = Row(
      children: titleWidgets,
    );
    return AppBar(
      shape: Border(
        bottom: BorderSide(
          color: borderColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: title,
    );
  }
}
