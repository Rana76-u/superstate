import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileImage(String imageLink) {
  return GestureDetector(
    onTap: () {
      ///Go to Profile
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: CachedNetworkImage(
        height: 35,
        width: 35,
        imageUrl: imageLink,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              //colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
            ),
          ),
        ),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  );
}