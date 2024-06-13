import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/SaveToGallery.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  const ImageDetailScreen(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Detail')),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool hasPermission = await requestStoragePermission();
              if (hasPermission) {
                final file = await DefaultCacheManager().getSingleFile(imageUrl);
                await saveImage(file.path, context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Permission to access storage denied'),
                  ),
                );
              }
            },
            child: const Text('Download Image'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to List'),
          ),
        ],
      ),
    );
  }

  Future<void> saveImage(String filePath, BuildContext context) async {
    Future<String> result = saveImageToGallery(filePath, context);
    result.then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value),
        ),
      );
    });
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      final result = await Permission.storage.request();
      return result.isGranted;
    }
    return status.isGranted;
  }
}
