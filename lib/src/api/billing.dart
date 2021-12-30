import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model.dart';

class BillingAPI {
  static String baseUri = dotenv.get("API_URL");
  static Future<List<Account>> getAccounts(Session session) async {
    Map<String, String> headers = {};
    headers['cookie'] = session.cookies!;
    final http.Response res = await http.get(
        Uri.parse('$baseUri/billing/account?active=true&reseller_seq=0'),
        headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> msg = jsonDecode(res.body);
      if (msg['success']) {
        return List<Account>.from(
            msg['data'].map((model) => Account.fromJson(model)));
      }
    }
    throw Exception('failed to get accounts');
  }

  static Future<void> logout(Session session) async {
    Map<String, String> headers = {};
    headers['cookie'] = session.cookies!;
    await http.get(Uri.parse('$baseUri/session/logout'), headers: headers);
  }
}
