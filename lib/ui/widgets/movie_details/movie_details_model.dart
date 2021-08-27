import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;
  Image? _poster = null;
  Image? _backDrop = null;
  bool _loading = false;
  late PaletteColor color;

  MovieDetailsModel(
    this.movieId,
  );

  MovieDetails? get movieDetails => _movieDetails;
  Image? get poster => _poster;
  Image? get backDrop => _backDrop;
  bool get isloading => _loading;

  Future<void> setupLocale(BuildContext context) async {
    _loading = true;
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.y(locale);
    await loadDetails();
  }

  Future<Image> _downloadImage(String src) async {
    return Image.network(ApiClient.imageUrl(src));
  }

  Future<void> loadDetails() async {
    //пропустил авайт этого надо дождаться

    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    final _post = _movieDetails?.posterPath;
    _post != null ? _poster = await _downloadImage(_post) : _poster = null;
    final _back = _movieDetails?.backdropPath;
    _back != null ? _backDrop = await _downloadImage(_back) : _backDrop = null;
    _updatePalettes();
    _loading = false;
    notifyListeners();
  }

  //загрузка цветта экрана
  _updatePalettes() async {
    final PaletteGenerator generator;
    generator = await PaletteGenerator.fromImage(_backDrop);
  }
}
