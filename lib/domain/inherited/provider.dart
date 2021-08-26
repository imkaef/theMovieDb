import 'package:flutter/material.dart';

//новый инхерит сделаный для того чтобы при ребилде он не терял свою модель
class NotifierProvider<Model extends ChangeNotifier> extends StatefulWidget {
  const NotifierProvider({
    Key? key,
    required this.create,
    required this.child,
  }) : super(key: key);

  final Model Function() create;
  final Widget child;

  

  @override
  _NotifierProviderState<Model> createState() =>
      _NotifierProviderState<Model>();

  static Model? watchOnModel<Model extends ChangeNotifier>(
      BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedNotifierProvider<Model>>()
        ?.model;
  }

  static Model? readFromModel<Model extends ChangeNotifier>(
      BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            _InheritedNotifierProvider<Model>>()
        ?.widget;
    return widget is _InheritedNotifierProvider<Model> ? widget.model : null;
  }
}

class _NotifierProviderState<Model extends ChangeNotifier>
    extends State<NotifierProvider<Model>> {
  late final Model _model;

  @override
  void initState() {
    _model = widget.create();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedNotifierProvider(model: _model, child: widget.child);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _InheritedNotifierProvider<Model extends ChangeNotifier>
    extends InheritedNotifier {
  //не забыть поменять от кого наследуется инхерит
  _InheritedNotifierProvider(
      {Key? key, required this.model, required this.child})
      : super(key: key, notifier: model, child: child);

  final Model model;
  final Widget child;
}

class Provider<Model> extends InheritedWidget {
  //не забыть поменять от кого наследуется инхерит
  Provider({Key? key, required this.model, required this.child})
      : super(key: key, child: child);

  final Model model;
  final Widget child;

  static Model? watch<Model>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<Model>>()?.model;
  }

  static Model? read<Model extends ChangeNotifier>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<Provider<Model>>()
        ?.widget;
    return widget is _InheritedNotifierProvider<Model> ? widget.model : null;
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return model != oldWidget.model;
  }
}
