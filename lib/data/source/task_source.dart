import 'dart:convert';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:tusk_app/common/url_endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:tusk_app/data/models/task.dart';

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

  static Future<bool> rejected(String reason, int id) async {
    try {
      final response =
          await http.patch(Uri.parse('$_baseUrl/$id/reject'), body: {
        'reason': reason,
        'rejectedDate': DateTime.now().toIso8601String(),
      });
      return response.statusCode == 200;
    } catch (e) {
      log("Failed reject task : ${e.toString()}");
      return false;
    }
  }

  static Future<bool> fixToQueue(int revision, int id) async {
    try {
      final response = await http.patch(Uri.parse('$_baseUrl/$id/fix'), body: {
        'revision': revision,
      });
      return response.statusCode == 200;
    } catch (e) {
      log("Failed reject task : ${e.toString()}");
      return false;
    }
  }

  static Future<bool> approvedDate(int id) async {
    try {
      final response =
          await http.patch(Uri.parse('$_baseUrl/$id/approve'), body: {
        'approvedDate': DateTime.now().toIso8601String(),
      });
      return response.statusCode == 200;
    } catch (e) {
      log("Failed reject task : ${e.toString()}");
      return false;
    }
  }

  static Future<Task?> findById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
      );
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        return Task.fromJson(Map.from(result));
      }
      return null;
    } catch (e) {
      log("Failed reject task : ${e.toString()}");
      return null;
    }
  }

  static Future<List<Task>?> getDataReview(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/review/asc'),
      );
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        return result.map((e) => Task.fromJson(Map.from(e))).toList();
      }
      return null;
    } catch (e) {
      log("Failed get data review : ${e.toString()}");
      return null;
    }
  }

  static Future<List<Task>?> progress(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/progress/$userId'),
      );
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        return result.map((e) => Task.fromJson(Map.from(e))).toList();
      }
      return null;
    } catch (e) {
      log("Failed get progress : ${e.toString()}");
      return null;
    }
  }

  static Future<Map?> statistic(int userId) async {
    List listStatus = ["Queue", "Review", "Approved", "Rejected"];
    Map stat = {};
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/stat/$userId'),
      );
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        for (String status in listStatus) {
          Map? found = result
              .where((element) => element['status'] == status)
              .firstOrNull;
          stat[status] = found?['total'] ?? 0;
        }
        return stat;
      }
      return null;
    } catch (e) {
      log("Failed get statistic : ${e.toString()}");
      return null;
    }
  }

  static Future<List<Task>?> whereUserAndStatus(
      int userId, String status) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId/$status'),
      );
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);

        return result.map((e) => Task.fromJson(Map.from(e))).toList();
      }
      return null;
    } catch (e) {
      log("Failed get statistic : ${e.toString()}");
      return null;
    }
  }
}
