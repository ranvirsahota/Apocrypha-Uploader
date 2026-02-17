import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:apocrypha_uploader/models/book.dart';

class ApocryphaApi {
  final String apiBaseUrl = 'http://localhost:5000/'; // Replace with actual API base URL

  Future<Book> uploadDiscovery(String token, String bookId, String discoveryDate, int? OS) async {
    print(bookId);
    print(token);
    // Implement the logic to upload the discovery to the Apocrypha API
    final String controllerURL = 'discovered/$bookId/'; // Replace with actual API URL
    final response = await http.put(
      Uri.parse("$apiBaseUrl/$controllerURL"),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'bookId': bookId,
        'discoveryDate': discoveryDate,
        'OS': OS,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Discovery uploaded successfully');
      return Book.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw FormatException('Failed to upload discovery: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}