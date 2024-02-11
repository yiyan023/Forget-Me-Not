import 'package:http/http.dart' as http;
import 'dart:async';

class MessagesNearApiService {
  final String baseUrl;

  MessagesNearApiService(this.baseUrl);

  Future<http.Response> getRequest(String endpoint, List<double> doubleList) async {
    // Construct the query parameters
    var queryParams = doubleList.asMap().map((key, value) => MapEntry('param$key', value.toString()));

    // Create the URL with query parameters
    var uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);

    // Make the GET request
    final response = await http.get(uri);

    // Check for successful response
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

