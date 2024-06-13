import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class FlickrApi {
  final String apiKey = 'cb7c5c39faa90bcadfbfba24cb484dee';

  Future<List<String>> fetchImages([String tags = '', String sort = '']) async {
    String method = 'flickr.photos.search';
    if(tags.trim().isEmpty) method = 'flickr.photos.getRecent';
    String urlStr = 'https://api.flickr.com/services/rest/?method=$method&api_key=$apiKey&tags=$tags&sort=$sort&format=json&nojsoncallback=1&extras=url_s';
    log('url request: $urlStr');
    final response = await http.get(Uri.parse(urlStr));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> photos = data['photos']['photo'];
      return photos.map((photo) => photo['url_s'] as String).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

}
