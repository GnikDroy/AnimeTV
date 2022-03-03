import 'package:flutter/material.dart';

AppBar get_app_bar(BuildContext context, Color color,
    {String title_str = 'Anime TV'}) {
  var title_widgets = <Widget>[];

  if (!(ModalRoute.of(context)?.canPop ?? false)) {
    title_widgets.add(const Icon(
      Icons.live_tv_outlined,
      size: 35,
      color: Color.fromARGB(230, 255, 255, 255),
    ));
    title_widgets.add(const SizedBox(width: 15));
  }

  title_widgets.add(Text(
    title_str,
    style: const TextStyle(
      color: Color.fromARGB(230, 255, 255, 255),
    ),
  ));

  final title = Row(
    children: title_widgets,
  );

  return AppBar(
    shape: Border(
      bottom: BorderSide(
        color: color,
      ),
    ),
    elevation: 0,
    backgroundColor: const Color(0x44000000),
    title: title,
  );
}
