import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType {
  png,
  svg,
}

class CustomImage extends StatelessWidget {
  final String? imageSrc;
  final Color? imageColor;
  final double? height;
  final double? scale;
  final double? width;
  final double? sizeWidth;
  final ImageType? imageType;
  final BoxFit? fit;
  final double horizontal;
  final double vertical;
  final BoxFit? boxFit;

  const CustomImage({
    required this.imageSrc,
    this.imageColor,
    this.sizeWidth,
    this.imageType,
    super.key,
    this.fit,
    this.scale,
    this.horizontal = 0.0,
    this.vertical = 0.0,
    this.boxFit,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // ✅ যদি null বা empty হয় → fallback
    if (imageSrc == null || imageSrc!.isEmpty) {
      imageWidget = const SizedBox(); // অথবা Placeholder()
    }
    // ✅ SVG handle
    else if (imageSrc!.toLowerCase().endsWith('.svg')) {
      imageWidget = SvgPicture.asset(
        imageSrc!,
        color: imageColor,
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.cover,
      );
    }
    // ✅ PNG/JPG handle
    else if (imageSrc!.toLowerCase().endsWith('.png') ||
        imageSrc!.toLowerCase().endsWith('.jpg') ||
        imageSrc!.toLowerCase().endsWith('.jpeg')) {
      imageWidget = Image.asset(
        imageSrc!,
        fit: fit,
        color: imageColor,
        height: height,
        width: width,
        scale: scale ?? 1,
      );
    }
    // ✅ Unknown format fallback
    else {
      imageWidget = const SizedBox(); // অথবা কোনো ডিফল্ট ইমেজ
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      width: sizeWidth,
      child: imageWidget,
    );
  }
}
