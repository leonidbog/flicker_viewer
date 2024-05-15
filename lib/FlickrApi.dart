import 'dart:convert';
import 'package:http/http.dart' as http;

class FlickrApi {
  final String apiKey = 'f341a37072b95196e1cc5449e1254715';

  Future<List<String>> fetchImages() async {
    final response = await http.get(
      Uri.parse('https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=$apiKey&format=json&nojsoncallback=1&extras=url_s'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> photos = data['photos']['photo'];
      return photos.map((photo) => photo['url_s'] as String).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
