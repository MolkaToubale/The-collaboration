import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import 'my_loading.dart';

class UserImageNetwork extends StatelessWidget {
  final double? height;
  final double? width;
  final String? image;
  final double? marginAsDouble;
  final Function()? function;

  const UserImageNetwork(
      {Key? key,
      this.height,
      this.width,
      this.image,
      this.function,
      this.marginAsDouble})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function!,
      child: Container(
        height: width ?? 35,
        width: height ?? 35,
        margin: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: bgColor,
          border: Border.all(color: Colors.orange, width: 3),
          boxShadow: const [
            BoxShadow(
                offset: Offset(1, 1), blurRadius: 5, color: Colors.black38)
          ],
        ),
        child: Container(
          width: width ?? 35 - 3,
          height: height ?? 35 - 3,
          margin: EdgeInsets.all(marginAsDouble!),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: image != 'Not mentioned'
              ? CachedNetworkImage(
                  imageUrl: image!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        /*colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.colorBurn)*/
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: MyLoading(),
                  ),
                  errorWidget: (context, url, error) {
                    return Material(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'lib/AppContent/assets/player.png',
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  width: width!,
                  height: height!,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "lib/AppContent/assets/player.png",
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class UserImageNetworkNoGest extends StatelessWidget {
  final double? height;
  final double? width;
  final String? image;
  final double? marginAsDouble;
  final Function()? function;

  const UserImageNetworkNoGest(
      {Key? key,
      this.height,
      this.width,
      this.image,
      this.function,
      this.marginAsDouble})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(marginAsDouble!),
      padding: const EdgeInsets.all(3),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 3),
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: image != null
          ? CachedNetworkImage(
              imageUrl: image!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    /*colorFilter:
                          ColorFilter.mode(Colors.red, BlendMode.colorBurn)*/
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: MyLoading(),
              ),
              errorWidget: (context, url, error) {
                return Material(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/icons/list.jpg',
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                );
              },
              width: width!,
              height: height!,
              fit: BoxFit.cover,
            )
          : Image.asset(
              "assets/icons/list.jpg",
              fit: BoxFit.cover,
            ),
    );
  }
}
