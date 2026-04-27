import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class ImageHelper {
  /// Returns an ImageProvider based on the URL scheme.
  /// Handles Network, Base64 embedded strings, and local Files.
  static ImageProvider getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    } else if (imageUrl.startsWith('data:image/')) {
      final base64Str = imageUrl.split(',').last;
      return MemoryImage(base64Decode(base64Str));
    } else {
      return FileImage(File(imageUrl));
    }
  }

  /// Returns a ready-to-use Image widget or a fallback Icon.
  static Widget getImageWidget(String? imageUrl, {BoxFit fit = BoxFit.cover}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image);
    }
    return Image(
      image: getImageProvider(imageUrl),
      fit: fit,
    );
  }
}
