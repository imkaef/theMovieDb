import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;
  Image? _poster = null;
  Image? _backDrop = null;
  bool _loading = false;
  late Color color;

 late bool _isFavorite;

  bool get isFavorite => _isFavorite;

  final _sessionDataProvider = SessionDataProvider();

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
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
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

    final _post = _movieDetails?.posterPath;
    _post != null ? _poster = await _downloadImage(_post) : _poster = null;
    final _back = _movieDetails?.backdropPath;
    _back != null ? _backDrop = await _downloadImage(_back) : _backDrop = null;
    _loading = false;
    if (_backDrop == null) return;
    notifyListeners();
  }

  //загрузка цветта экрана
  Future<Color> _updatePalettes(Image img) async {
    final PaletteGenerator generator =
        await PaletteGenerator.fromImageProvider(img.image);
    return color = generator.lightMutedColor!.color;
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

  // await PaletteGenerator.fromImageProvider(img.image);
}
  //попробывать с ключевым словом ретерн сделатьт проверку на нот налл
