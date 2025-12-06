import 'dart:convert';
import 'dart:developer';

import 'package:tusk_app/common/url_endpoint.dart';
import 'package:tusk_app/data/models/user.dart';
import 'package:http/http.dart' as http;

class UserSource {
  ///`'${Url.baseurl}/users'`
  static const String _baseUrl = '${Url.baseurl}/users';

  static Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$_baseUrl/login'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }));
      log("Cek result response : $response");
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        return User.fromJson(Map.from(result));
      }
      return null;
    } catch (e) {
      log("Failed login user : ${e.toString()}");
      return null;
    }
  }

  static Future<bool> insertEmployee(String name, String email) async {
    try {
      final response = await http.post(Uri.parse(_baseUrl),
          body: jsonEncode({
            'name': name,
            'email': email,
          }));
      return response.statusCode == 201;
    } catch (e) {
      log("Failed add employee : ${e.toString()}");
      return false;
    }
  }

  static Future<bool> delete(int userId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$userId'));
      log("Success delete user $response");
      return response.statusCode == 200;
    } catch (e) {
      log("Failed deleted user : ${e.toString()}");
      return false;
    }
  }

  static Future<List<User>?> getListEmployee() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/Employee'));
      log("Success get users user $response");
      if (response.statusCode == 200) {
        List res = jsonDecode(response.body);
        return res.map((e) => User.fromJson(Map.from(e))).toList();
      }
      return null;
    } catch (e) {
      log("Failed get list user : ${e.toString()}");
      return null;
    }
  }
}
