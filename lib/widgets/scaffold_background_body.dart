import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';

class ScaffoldBackgroundedBody extends ConsumerWidget {
  final Widget theChild;
  const ScaffoldBackgroundedBody({super.key, required this.theChild});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ViNewsAppImagesPath.appBackgroundImage),
          opacity: 0.15,
          fit: BoxFit.cover,
        ),
      ),
      child: theChild,
    );
  }
}
