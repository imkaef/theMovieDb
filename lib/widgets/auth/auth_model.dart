import 'package:flutter/cupertino.dart';

class AuthModel extends ChangeNotifier {
  //Указать от кого наследуется
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  Future<void> auth(BuildContext context) async {}
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
