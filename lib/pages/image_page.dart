import 'dart:ui';

import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  final String imageId;
  final String imageUrl;
  final double height;
  final double width;
  final VoidCallback onTap;

  const PhotoHero({
    required this.imageId,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.onTap,
  });

  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Hero(
        tag: imageId,
        child: Material(
          color: Colors.red,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
