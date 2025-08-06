import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'my_loading.dart';

class MyImage extends StatelessWidget {
  const MyImage({
    super.key,
    this.scale = 1,
    required this.image,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.onTap,
  });

  final double scale;
  final String image;
  final Alignment alignment;
  final BoxFit fit;
  final Widget? errorWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: image,
        fit: fit,
        scale: scale,
        alignment: alignment,
        placeholder: (context, url) => MyLoading(),
        errorWidget: (context, url, error) =>
            errorWidget ??
            MyImage(
              image:
                  "https://pixsector.com/cache/517d8be6/av5c8336583e291842624.png",
            ),
      ),
    );
  }
}

class MyImageAssets extends StatelessWidget {
  const MyImageAssets({
    super.key,
    required this.assets,
    this.scale = 4,
    this.fit = BoxFit.cover,
    this.color,
  });

  final String assets;
  final double scale;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      Image.asset(assets, scale: scale, fit: fit, color: color);
}
