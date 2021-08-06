import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/const/routes_screen.dart';
import 'package:the_movie_db/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_widget.dart';

import 'widgets/customProgressBarWidget.dart';

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
        RouteScreen.auth: (context) => AuthWidget(),
        RouteScreen.main_screen: (context) => MainScreenWidget(),
        RouteScreen.example: (context) => CustomProgressBarWidget(),
      },
      initialRoute: RouteScreen.example,
    );
  }
}
