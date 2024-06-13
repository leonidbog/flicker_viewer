import 'package:flicker_viewer/views/ImageListScreen.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flickr Image Gallery',
      home: ImageListScreen(),
    );
  }
}

