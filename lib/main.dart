import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/const/app_images.dart';
import 'package:the_movie_db/const/routes_screen.dart';
import 'package:the_movie_db/widgets/auth/auth_model.dart';
import 'package:the_movie_db/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/widgets/movie_list/movie_list_widget.dart';

import 'widgets/customProgressBarWidgetScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor:
                AppColors.mainDarkBlue), // установили в тему значение цвета
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainDarkBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey),
      ),
      routes: {
        RouteScreen.auth: (context) => AuthProvider(child: const AuthWidget(),model: AuthModel(),),
        RouteScreen.mainScreen: (context) => MainScreenWidget(),
        RouteScreen.example: (context) => CustomProgressBarWidget(),
        RouteScreen.movieDetails: (context) {
// final id = ModalRoute.of(context)!.settings.arguments as int;
          // так плохо есди я дам другой или налл прога крашиться по этому делаем иначе
          //  good case
          final arguments = ModalRoute.of(context)?.settings.arguments as Movie;
          if (arguments.id is int) {
            return MovieDetailsWidget(
              movie: arguments,
            );
          } else {
            return MovieDetailsWidget(
              movie: Movie(
                  id: 18,
                  imageName: AppImages.moviePlaceHolder,
                  title: 'Oshibka',
                  time: 'time',
                  description: 'description'),
            );
          }
        },
      },
      initialRoute: RouteScreen.auth,
    );
  }
}
