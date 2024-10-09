import 'dart:convert';
import 'package:http/http.dart' as http;

class PixabayService {
  final String apiKey = '46421467-3a36e2a5500c410be59b39ed9';
  final String baseUrl = 'https://pixabay.com/api/';

  /// this function is written for get the data from the API

  Future<List<dynamic>> fetchImages(String query, int page) async {
    final url = Uri.parse(
        '$baseUrl?key=$apiKey&q=$query&image_type=photo&pretty=true&page=$page');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['hits'];
    } else {
      throw Exception('Failed to load images');
    }
  }
}
