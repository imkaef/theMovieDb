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
  late int _currentPage;
  //добавляем защиту
  late int _totalPage;
  var _isLoadingInProgres =
      false; //когда мы грузим страницу не надо вызывать следующую загрузку

//настройка локализации
  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMEd(locale);
    _movies.clear();
    _currentPage = 0;
    _totalPage = 1;
    loadMovies();
  }

  void setLocale(String l) {
    _dateFormat = DateFormat.yMMMEd(l);
    _movies.clear();
    lM(l);
  }

  Future<void> lM(String l) async {
    final responceMovies = await _apiClient.popularMovie(2, l);
    _movies.addAll(responceMovies.movies);
    notifyListeners();
  }

  Future<void> loadMovies() async {
    if (_isLoadingInProgres || _currentPage >= _totalPage) return;
    _isLoadingInProgres = !_isLoadingInProgres;
    final _nextpage = _currentPage + 1;
    try {
      final responceMovies = await _apiClient.popularMovie(_nextpage, _locale);
      //если и будет ощиька то только сверху и поля ниже не выполнятся
      _movies.addAll(responceMovies.movies);
      _currentPage = responceMovies.page;
      _totalPage = responceMovies.totalPages;
      _isLoadingInProgres = !_isLoadingInProgres;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgres = !_isLoadingInProgres;
    }
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void showedMovieAtIndex(int index) {
    //когда список фильмов подходит к концу нажо вызвать загрузку
    if (index < _movies.length - 1) return;
    loadMovies();
    print(index);
  }
}
