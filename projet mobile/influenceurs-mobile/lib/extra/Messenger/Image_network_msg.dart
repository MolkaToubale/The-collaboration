import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'my_loading.dart';

class ImageNetworkMsg extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;

  const ImageNetworkMsg({Key? key, this.image, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: CachedNetworkImage(
        width: width,
        imageUrl: image!,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          width: width,
          height: height,
          child:
              const MyLoading() 

          ,
        ),
        errorWidget: (context, url, error) {
          return Material(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              'images/notFound.png',
              width: width,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
