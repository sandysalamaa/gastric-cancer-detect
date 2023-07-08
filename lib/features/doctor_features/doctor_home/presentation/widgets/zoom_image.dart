import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/dimenssions/size_config.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';

class ZoomableImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ZoomableImage({Key? key, required this.imageUrl, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20.0),
        minScale: 0.1,
        maxScale: 5.0,
        child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            fit: BoxFit.fill,
            placeholder: (context, url) => Image.asset(
                  logoImage,
                  height: 50,
                  fit: BoxFit.fill,
                ),
            errorWidget: (context, url, error) => Image.asset(
                  logoImage,
                  fit: BoxFit.fill,
                )),
      ),
    );
  }
}
