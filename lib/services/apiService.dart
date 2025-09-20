import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.4:5000";

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/user/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
     );
    if (response.statusCode == 200) {

      // The request was successful. Check if the body is not empty.
      if (response.body.isNotEmpty) {
        final data = json.decode(response.body);
        print('Data received successfully: $data');
      } else {
        print('Success, but no data in the response body.');
      }
    } else {
      // The request failed. Print the status code and any error message.
      print('Request failed with status code: ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print('Error message from server: ${response.body}');
      }
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/user/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }
  
}
