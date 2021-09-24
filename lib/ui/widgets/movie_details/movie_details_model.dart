import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  var _firstOpen = true;
  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;
  Image? _poster = null;
  Image? _backDrop = null;
  bool _loading = false;
  //Color _color = Colors.lime;
  late PaletteGenerator _colorsList;
  late bool _isFavorite;

  bool get isFavorite => _isFavorite;

  final _sessionDataProvider = SessionDataProvider();
  MovieDetailsModel(
    this.movieId,
  );
  @override
  String toString() {
    return '${_firstOpen.toString()}  $movieId';
  }

  MovieDetails? get movieDetails => _movieDetails;
  Image? get poster => _poster;
  Image? get backDrop => _backDrop;
  bool get isloading => _loading;
  PaletteGenerator get getColorList => _colorsList;

  Future<void> setupLocale(BuildContext context) async {
    //Если модель открыта впервый раз то надо делать загрузку
    // А если модель существует то в ней есть данные и загружать данные из инета снова не надо
    if (_firstOpen != true) return;
    _loading = true;
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
    _firstOpen = false;
  }

  Future<Image> _downloadImage(String src) async {
    final image = Image.network(
      ApiClient.imageUrl(src),
      filterQuality: FilterQuality.high,
    );
    return image;
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> loadDetails() async {
    //пропустил авайт этого надо дождаться

    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    final sessionId = await SessionDataProvider().getSessionId();
    if (sessionId != null) {
      _isFavorite = await _apiClient.isFavorite(movieId, sessionId);
    }

    final _back = _movieDetails?.backdropPath;
    _back != null ? _backDrop = await _downloadImage(_back) : _backDrop = null;
    final _front = _movieDetails?.posterPath;
    _front != null ? _poster = await _downloadImage(_front) : _poster = null;
    await createColor(poster);
    _loading = false;
    notifyListeners();
  }

  //загрузка цветта экрана
  Future<void> createColor(Image? img) async {
    PaletteGenerator generator;
    if (img == null) return;
    generator = await PaletteGenerator.fromImageProvider(img.image);
    if (generator.dominantColor?.color != null) {
      _colorsList = generator;
      return;
    }
    return;
  }

  void onTrailerTap(BuildContext context, String trailerKey) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieTrailer,
        arguments: trailerKey);
  }

  Future<void> onFavoriteTap() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    final contentId = movieDetails?.id;
    if (sessionId == null || accountId == null || contentId == null) return;

    _apiClient.markIsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.movie,
        mediaId: contentId,
        isFavorite: !isFavorite);

    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  @override
  void dispose() {
    print('${movieDetails?.title} Сработал диспоуз и модель удалилась');
    // TODO: implement dispose
    super.dispose();
  }

  // await PaletteGenerator.fromImageProvider(img.image);
}
//попробывать с ключевым словом ретерн сделатьт проверку на нот налл
