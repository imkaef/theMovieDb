import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/data/data_providers/session_data_provider.dart';
import 'package:the_movie_db/theme/presenter/navigation/main_navigation.dart';

class SerialsListWidget extends StatelessWidget {
  const SerialsListWidget({
    Key? key,
  }) : super(key: key);
  void onpressed(BuildContext context) {
    final provider = SessionDataProvider();
    provider.setSessionId(null);
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Text('Exit from app'),
      onPressed: () => onpressed(context),
    ));
  }
}
