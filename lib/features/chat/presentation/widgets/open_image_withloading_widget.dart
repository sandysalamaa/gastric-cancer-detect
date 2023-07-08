import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_message_view.dart';
import 'message_card_widget.dart';

class ImageWithLoading extends StatefulWidget {
  final String imageUrl;
  const ImageWithLoading({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ImageWithLoadingState createState() => _ImageWithLoadingState();
}

class _ImageWithLoadingState extends State<ImageWithLoading> {
  late final String imageUrl;
  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  void _openImageView(String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => ImageMessageView(imageUrl: url)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openImageView(imageUrl),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .30,
        width: MediaQuery.of(context).size.width * .50,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          progressIndicatorBuilder: (_, child, loadingProgress) {
            if (loadingProgress.totalSize == null) {
              return const EmptyContainer();
            }
            return Stack(
              children: <Widget>[
                const EmptyContainer(),
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor:
                        loadingProgress.downloaded / loadingProgress.totalSize!,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
