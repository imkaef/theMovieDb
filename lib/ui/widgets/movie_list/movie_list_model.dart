import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/movie.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';

//настройка локализации
  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMEd(locale);
    _movies.clear();
    loadMovies();
  }

  void setLocale(String l) {
    _dateFormat = DateFormat.yMMMEd(l);
    _movies.clear();
    lM(l);
  }

  Future<void> lM(String l) async {
    final responceMovies = await _apiClient.popularMovie(1, l);
    _movies.addAll(responceMovies.movies);
    notifyListeners();
  }

  Future<void> loadMovies() async {
    final responceMovies = await _apiClient.popularMovie(1, _locale);
    _movies.addAll(responceMovies.movies);
    notifyListeners();
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }
}
