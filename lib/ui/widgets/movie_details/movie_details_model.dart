import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;

  MovieDetailsModel(
    this.movieId,
  );

  MovieDetails? get movieDetails => _movieDetails;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMEd(locale);
    await loadDetails();
  }

  Future<void> loadDetails() async {
    //пропустил авайт этого надо дождаться
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }
}
