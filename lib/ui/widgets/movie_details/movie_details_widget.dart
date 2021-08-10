import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_screen_cast_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key, required this.movie}) : super(key: key);
  final int movie;
  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.toString()),
      ),
      body: ColoredBox(
        color: AppColors.blackBackgroundMovieDetail,
        child: ListView(
          children: [
            MovieDetailsMainInfoWidget(),
            MovieDetailsMainScreenCastWidget(),
          ],
        ),
      ),
    );
  }
}