import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../app/services/my_config.dart';
import '../utils/my_colors.dart';

class MyImage extends StatelessWidget {
  const MyImage(
    this.image, {
    super.key,
    this.scale = 1,
    this.width,

    this.fit = BoxFit.cover,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.onTap,
  });

  final double scale;
  final double? width;
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
        width: width,
        imageUrl: "${MyConfig.apiUrl}/${dotenv.env["API_STORAGE"]}/$image",
        imageRenderMethodForWeb: .HttpGet,
        fit: fit,
        scale: scale,
        alignment: alignment,
        placeholder: (context, url) =>
            const ColoredBox(color: MyColors.selected),
        errorWidget: (context, url, error) =>
            errorWidget ??
            const ColoredBox(
              color: MyColors.selected,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 16,
                  color: MyColors.primary80,
                ),
              ),
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

class MyThumbnail extends StatelessWidget {
  const MyThumbnail({super.key, this.image, this.size = 48});

  final String? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: MyColors.selected,
      child: image == null ? null : MyImage(image!),
    );
  }
}
