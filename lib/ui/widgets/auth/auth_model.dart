import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  //Указать от кого наследуется
  final loginTextController = TextEditingController(text: 'student448');
  final passwordTextController = TextEditingController(text: '13SerG37');
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthinProgress => _isAuthProgress;

  // String? _sessionId;
// добавляем метод из apiclient
  final _apiKlient = ApiClient();

  final _sessionDataProvider = SessionDataProvider();

  Future<void> auth(BuildContext context) async {
    print('auth start');
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      print('auth login and password not secure');
      _errorMessage = "Заполните логин и пароль";
      notifyListeners();
      return;
    }
    print('auth login and password not secure');
    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? sessionId;
    try {
      sessionId = await _apiKlient.auth(username: login, password: password);
      print('$sessionId');
    } catch (e) {
      _errorMessage = 'Неправильный логин или пароль!';
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null) {
      _errorMessage = 'Не получен id сессии';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);

    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen);
    //notifyListeners();
    //_sessionId =_apiKlient.auth(username: login, password: password);
  }
}

// class AuthProvider extends InheritedWidget {
//   AuthProvider({Key? key, required this.child}) : super(key: key, child: child);

//   final Widget child;

//   static AuthProvider? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }

//   @override
//   bool updateShouldNotify(AuthProvider oldWidget) {
//     return true;
//   }
// } из этого делаем это

class AuthProvider extends InheritedNotifier {
  //не забыть поменять от кого наследуется инхерит
  AuthProvider({Key? key, required this.model, required this.child})
      : super(key: key, notifier: model, child: child);
  final AuthModel model;
  final Widget child;

  static AuthProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }

  static AuthProvider? read(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
    return widget is AuthProvider ? widget : null;
  }
}
