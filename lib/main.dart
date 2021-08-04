import 'package:flutter/material.dart';
import 'package:the_movie_db/const/routes_screen.dart';
import 'package:the_movie_db/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_widget.dart';

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
            backgroundColor: const Color.fromRGBO(
                3, 37, 65, 1)), // установили в тему значение цвета
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        RouteScreen.auth: (context) => AuthWidget(),
        RouteScreen.main_screen: (context) => MainScreenWidget()
      },
      initialRoute: RouteScreen.auth,
    );
  }
}
