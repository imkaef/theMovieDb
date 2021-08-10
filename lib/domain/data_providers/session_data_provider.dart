// тут храним сессию которую получаем на экране auth
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session-id';
}

class SessionDataProvider {
  final _secureStorage = FlutterSecureStorage();
  Future<String?> getSessionId() => _secureStorage.read(key: _Keys.sessionId);
  Future<void> setSessionId(String? sessionId) {
    if (sessionId != null) {
      return _secureStorage.write(key: _Keys.sessionId, value: sessionId);
    } else {
      return _secureStorage.delete(key: _Keys.sessionId);
    }
  }
}
