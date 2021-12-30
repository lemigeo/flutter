import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Cookies {
  static CookieManager cookieManager = CookieManager.instance();
  static Future<String> getCookies(uri) async {
    Cookie? token =
        await cookieManager.getCookie(url: uri, name: "connect.sid");
    if (token != null) {
      return 'i18n_redirected=en; ${token.name}=${token.value}';
    }
    return "";
  }
}
