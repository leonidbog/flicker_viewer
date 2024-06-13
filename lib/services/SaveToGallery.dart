import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';

Future<String> saveImageToGallery(String filePath, BuildContext context) async {
  try {
    bool? success = await GallerySaver.saveImage(filePath);
    if (success!) {
      return 'Image saved to gallery';
    } else {
      return 'Failed to save image';
    }
  } catch (e) {
    return 'Error saving image: $e';
  }
}