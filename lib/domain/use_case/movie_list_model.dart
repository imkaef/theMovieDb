import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/data/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/movie.dart';
import 'package:the_movie_db/domain/entity/popular_movie_response.dart';
import 'package:the_movie_db/theme/presenter/navigation/main_navigation.dart';


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
  String? _searchQuery;
  // в зависимости от того есть ли это поле мы менеям наше состояние 68 19 20

  //каждое нажатие клавиши провоцирует запрос в инет на фильмы это не очень хорошо
  //чтобы это избежать нужен таймер
  Timer? searchDelay;
//настройка локализации
  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMEd(locale);
    await resetList();
    //тут только то что связанно с локалью
  }

  Future<void> resetList() async {
    //так как загрузка есть это асигхронная операция по этому это фьюче войд
    _movies.clear();
    _currentPage = 0;
    _totalPage = 1;
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgres || _currentPage >= _totalPage) return;
    _isLoadingInProgres = !_isLoadingInProgres;
    final _nextpage = _currentPage + 1;
    try {
      final responceMovies = await _loadMovies(_nextpage, _locale);
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
    _loadNextPage();
    print(index);
  }

  // добавляем методы для поиска фильмов
  Future<void> searchMovie(String text) async {
    //каждый раз когда чтото будет вызываться будет вызываться таймер
    // Через секунду после того как мы сюда вобьем вызовется таймер а потом добавиться
    searchDelay?.cancel();
    // каждый раз когда мы вбиваем букву высываются таймеры поо очереди но всё рано вызывается это 6 раз
    // по этому серч кэнсл отменяет предыдущий таймер и если юзер вобьет букву таймер отменится и запуститься снова
    //поиск в таком случае начнется через секунду после того как пользователь закончил ввод
    // этим мы экономим трафик так как серч вызывается 1 раз а не столько сколько букв
    searchDelay = Timer(Duration(seconds: 1), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await resetList();
    });
  }

// если квери не пустое то вы возвращем поиск фильмов, если пустое то выводим список фильмов
  Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return _apiClient.popularMovie(nextPage, locale);
    } else {
      return _apiClient.searchMovie(nextPage, locale, query);
    }
  }
}
