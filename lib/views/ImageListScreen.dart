
import 'package:flutter/material.dart';
import '../services/FlickrApi.dart';
import 'FilterScreen.dart';
import 'ImageDetailScreen.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key});

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  late Future<List<String>> images;
  String tags = '';
  String sort = 'relevance';

  @override
  void initState() {
    super.initState();
    images = FlickrApi().fetchImages(tags, sort);
  }

  void updateFilters(String newTags, String newSort) {
    setState(() {
      tags = newTags;
      sort = newSort;
      images = FlickrApi().fetchImages(tags, sort);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flickr Photos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(tags: tags, sort: sort),
                ),
              );

              if (result != null) {
                updateFilters(result['tags'], result['sort']);
              }
            },
          ),
        ],
      ),
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
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
