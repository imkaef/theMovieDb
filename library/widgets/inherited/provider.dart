import 'package:flutter/material.dart';

class NotifierProvider<Model extends ChangeNotifier> extends InheritedNotifier {
  //не забыть поменять от кого наследуется инхерит
  NotifierProvider({Key? key, required this.model, required this.child})
      : super(key: key, notifier: model, child: child);

  final Model model;
  final Widget child;

  static Model? watch<Model extends ChangeNotifier>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NotifierProvider<Model>>()
        ?.model;
  }

  static Model? read<Model extends ChangeNotifier>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NotifierProvider<Model>>()
        ?.widget;
    return widget is NotifierProvider<Model> ? widget.model : null;
  }
}
