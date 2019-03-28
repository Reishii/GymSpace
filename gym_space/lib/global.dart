import 'logic/user.dart';
import 'package:GymSpace/logic/auth.dart';

class GlobalSettings {
  static Future<String> currentUser;
  static User currentTestUser;

  static Auth auth = Auth();
  static AuthStatus authStatus = AuthStatus.notLoggedIn;
}