import 'user.dart';

class Session {
  late final User? user;
  late final String? cookies;

  Session(this.user, this.cookies);

  @override
  String toString() {
    if (user != null && cookies != null) {
      return 'cookies[${cookies!}] User ${user!.name}';
    } else {
      return "Empty session";
    }
  }
}
