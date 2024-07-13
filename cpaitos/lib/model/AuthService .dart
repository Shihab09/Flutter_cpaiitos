import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String baseUrl =
      'http://cpatos.gov.bd/tosapi'; // Replace this with your API base URL

  AuthService(this.baseUrl);

  dynamic login(String username, String password) async {
    String success;
    String message;
    final url_login = Uri.parse('$baseUrl/auth/login.php');
    print(url_login);
    final body = {'username': username, 'password': password};
    final response = await http.post(url_login, body: body);

    print(response.statusCode);

    if (response.statusCode == 200) {
      // You might receive a token or user data in the response to manage the user session.
      final jsondata = json.decode(response.body);
      success = jsondata['success'];
      message = jsondata['message'];
      print(success);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('success', success);
      pref.setString('message', message);
      if (success == '1') {
        // pref.setString('jsondata', jsondata);

        return true;
      } else {
        // Failed login
        return false;
      }
    }
  }
}
