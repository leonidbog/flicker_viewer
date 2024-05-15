import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'FlickrApi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flickr Image Gallery',
      home: ImageListScreen(),
    );
  }
}

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  late Future<List<String>> images;

  @override
  void initState() {
    super.initState();
    images = FlickrApi().fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flickr Images')),
      body: FutureBuilder<List<String>>(
        future: images,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String imageUrl = snapshot.data![index];
                return ListTile(
                  title: Image.network(imageUrl),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetailScreen(imageUrl))),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Detail')),
      body: Column(
        children: [
          Image.network(imageUrl),
          ElevatedButton(
            onPressed: () async {
              bool hasPermission = await requestStoragePermission();
              if (hasPermission) {
                final file = await DefaultCacheManager().getSingleFile(imageUrl);

                //await saveImage(file);


              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Permission to access storage denied'),
                  ),
                );
              }
            },
            child: Text('Download Image'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back to List'),
          ),
        ],
      ),
    );
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
