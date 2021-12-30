import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model.dart';

class IamAPI {
  static String baseUri = dotenv.get("API_URL") + '/iam';
  static Future<List<User>> getUsers(Session session) async {
    Map<String, String> headers = {};
    headers['cookie'] = session.cookies!;
    final http.Response res =
        await http.get(Uri.parse('$baseUri/user'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> msg = jsonDecode(res.body);
      if (msg['success']) {
        return List<User>.from(
            msg['data'].map((model) => User.fromJson(model)));
      }
    }
    throw Exception('failed to get users');
  }

  static Future<User> getUser(Session session, int seq) async {
    Map<String, String> headers = {};
    headers['cookie'] = session.cookies!;
    final http.Response res = await http
        .get(Uri.parse('$baseUri/user/${seq.toString()}'), headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> msg = jsonDecode(res.body);
      if (msg['success']) {
        return User.fromJson(msg['data']);
      }
    }
    throw Exception('failed to get user');
  }
}
