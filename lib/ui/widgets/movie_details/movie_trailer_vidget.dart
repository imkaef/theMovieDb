import 'package:flutter/material.dart';

class MovieTrailerWidget extends StatefulWidget {
  final youTubeKey;
  MovieTrailerWidget({Key? key, required this.youTubeKey}) : super(key: key);

  @override
  _MovieTrailerWidgetState createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
