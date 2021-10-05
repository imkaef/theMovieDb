
import 'package:the_movie_db/data/data_providers/session_data_provider.dart';

class MyAppModel {
  final _sessionProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionProvider.getSessionId();
    _isAuth = (sessionId != null);
    // if (sessionId != null) {
    //   _isAuth = true;
    // } else {
    //   _isAuth = false;
    // }
  }
}
