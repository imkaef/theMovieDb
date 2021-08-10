import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/const/app_images.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_model.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/ui/widgets/customProgressBarWidgetScreen.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = 'main_screen';
  static const movieDetails = 'main_screen/movie_details';
  static const example = 'example_screen';
}

// утащим роуты для удобного использования в отдельный файл
class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth: (context) => AuthProvider(
          child: const AuthWidget(),
          model: AuthModel(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => MainScreenWidget(),
    MainNavigationRouteNames.example: (context) => CustomProgressBarWidget(),
    MainNavigationRouteNames.movieDetails: (context) {
// final id = ModalRoute.of(context)!.settings.arguments as int;
      // так плохо есди я дам другой или налл прога крашиться по этому делаем иначе
      //  good case
      final arguments = ModalRoute.of(context)?.settings.arguments as int;
      if (arguments is int) {
        return MovieDetailsWidget(
          movie: arguments,
        );
      } else {
        return MovieDetailsWidget(
          movie: 0,
        );
      }
    },
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
            builder: (context) => MovieDetailsWidget(movie: movieId));
      default:
        const widget = Text('Navigation error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
