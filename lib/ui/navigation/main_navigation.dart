import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/inherited/provider.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_model.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_model.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_trailer_vidget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
  static const movieTrailer = '/movie_details/trailer';
  static const example = 'example_screen';
}

// утащим роуты для удобного использования в отдельный файл
class MainNavigation {
  // Сюда сохраняем созданные модельки
  Map<int, MovieDetailsModel> modelMap = {};

  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
          child: const AuthWidget(),
          create: () => AuthModel(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
          child: MainScreenWidget(),
          create: () => MainScreenModel(),
        ),

    //MainNavigationRouteNames.example: (context) => CustomProgressBarWidget(),
  };
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        if (modelMap.isNotEmpty == true ||
            modelMap.containsKey(movieId) == false)
          modelMap.addAll({movieId: MovieDetailsModel(movieId)});
        print("Values");
        for (var value in modelMap.values) {
          print(value.movieDetails?.title);
        }
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => modelMap[movieId] as MovieDetailsModel,
            isManagingModel: false,
            // create: () => MovieDetailsModel(movieId),
            // create: () => modelMap[movieId] != null
            //     ? modelMap[movieId]
            //     : MovieDetailsModel(movieId),
            child: MovieDetailsWidget(),
          ),
        );
      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (context) => MovieTrailerWidget(youTubeKey: youTubeKey),
        );
      default:
        const widget = Text('Navigation error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
