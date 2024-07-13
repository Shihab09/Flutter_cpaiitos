import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/urlconstants.dart' as url;

class PilotageLandingService {
  Future<String> fetchTotalData() async {
    final body = {'user_id': 'p497'};
    final urlString = Uri.parse(url.UrlConstants().TOTALCOUNTAPI());
    print(urlString);
    final response = await http.post(urlString, body: body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("from service====");
      var jsonData = json.decode(response.body);
      print(jsonData['data']);
      print(jsonDecode(response.body));

      return jsonData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load count');
    }
  }
}
