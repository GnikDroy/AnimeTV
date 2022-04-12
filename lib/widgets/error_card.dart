import 'package:anime_tv/widgets/slant_gradient_container.dart';
import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String msg;
  const ErrorCard(this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlantGradientBackgroundContainer(
        colors: [Colors.red, Colors.red.withOpacity(0.7)],
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 35),
              const SizedBox(height: 10),
              Text(msg, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

const genericNetworkError = ErrorCard(
  "Cannot connect to server. "
  "Make sure you have access to the internet. "
  "Retry after a brief period of time. "
  "If problem persists, report this to the developer.",
);
