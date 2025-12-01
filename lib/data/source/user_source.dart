import 'dart:convert';
import 'dart:developer';

import 'package:tusk_app/common/url_endpoint.dart';
import 'package:tusk_app/data/models/user.dart';
import 'package:http/http.dart' as http;

class UserSource {
  static const String _baseUrl = '${Url.baseurl}/users';

  static Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$_baseUrl/login'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }));
      log("Cek result response : ${response}");
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        return User.fromJson(Map.from(result));
        log("Cek result body : ${result}");
      }
      return null;
    } catch (e) {
      log("Failed login user : ${e.toString()}");
      return null;
    }
  }
}
