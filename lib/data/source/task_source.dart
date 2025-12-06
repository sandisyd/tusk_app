import 'dart:convert';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:tusk_app/common/url_endpoint.dart';
import 'package:http/http.dart' as http;

class TaskSource {
  ///`'${Url.baseurl}/tasks'`
  static const String _baseUrl = '${Url.baseurl}/tasks';

  static Future<bool> insertTask(
      String title, String description, String dueDate, int userId) async {
    try {
      final response = await http.post(Uri.parse(_baseUrl),
          body: jsonEncode({
            'title': title,
            'description': description,
            'status': 'Queue',
            'dueDate': dueDate,
            'userId': userId
          }));
      return response.statusCode == 201;
    } catch (e) {
      log("Failed add task : ${e.toString()}");
      return false;
    }
  }

  static Future<bool> deleteTask(int idTask) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$idTask'));
      log("Success delete task $response");
      return response.statusCode == 200;
    } catch (e) {
      log("Failed deleted user : ${e.toString()}");
      return false;
    }
  }

  static Future<bool> submitTask(int idTask, XFile file) async {
    try {
      final req = http.MultipartRequest(
          'PATCH', Uri.parse('$_baseUrl/$idTask/submit'))
        ..fields['submitDate'] = DateTime.now().toIso8601String()
        ..files.add(await http.MultipartFile.fromPath('attachment', file.path,
            filename: file.name));

      final res = await req.send();
      return res.statusCode == 200;
    } catch (e) {
      log("Failed submit task : ${e.toString()}");
      return false;
    }
  }
}
