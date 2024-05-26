import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://api.jikan.moe/v4/anime/';

  Future<Map<String, dynamic>> fetchAnimeDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return {
        'mal_id': data['mal_id'],
        'url': data['url'],
        'images': data['images']['jpg']['image_url'],
        'title': data['title'],
        'synopsis': data['synopsis'],
        'broadcast': data['broadcast']['string'],
      };
    } else {
      throw Exception('Failed to load anime details');
    }
  }
}
