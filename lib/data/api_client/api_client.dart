import 'dart:convert';
import 'dart:io';

import 'package:the_movie_db/domain/entity/movie_details.dart';
import 'package:the_movie_db/domain/entity/popular_movie_response.dart';

// перечисление ошибок
enum ApiClientExceptionType { Network, Auth, Other }
enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

//Создаем класс ошибок для этого имплементируем класс Exception
// Всего определили 3 типа ошибок Сервер, сеть на устройстве, ошибки с сервера не верный логин или пароль
class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  static String imageUrl(String path) {
    return '$_imageUrl$path';
  }

  final _client = HttpClient();
  static const _host =
      'https://api.themoviedb.org/3'; //куда мы юудем отправлять запросы все запросы начинаются с этого урл
  static const _imageUrl =
      'https://image.tmdb.org/t/p/w500'; // если нужны картинки они лежат тут
  static const _apiKey =
      '5eb1af50a385519917194d83bbebfab3'; // апи кей этот ключ в личном кабинете с помощью него можно работать с прогой
  // надо сделать 3 запроса мэйк токен
  // валидате юзер
  // make session

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parametrs,
  ]) async {
    final url = _makeUri(path, parametrs);
    try {
      final request = await _client.getUrl(url);
      final responce = await request.close();
      final dynamic json = (await responce.jsonDecode());
      _validateResponse(responce, json);
      final result = parser(json);
      return result;
      // Вот сюда
    } on SocketException {
      // Если ошибка с сетью мы генерируем ощибку и выходим
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      // Ессли получаем нашу ощибку описанную через if то мы её просто пробрасываем наверх
      rethrow;
    } catch (e) {
      print(e);
      // и если случилось что не наша и не сокет то это другие ошибки
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> bodyParametrs,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParametrs,
  ]) async {
    try {
      final url = _makeUri(path, urlParametrs);
      final request = await _client.postUrl(
        url,
      );
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParametrs));
      final responce = await request.close();
      final dynamic json = (await responce.jsonDecode());
      _validateResponse(responce, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> auth(
      {required String username, required String password}) async {
    final token =
        await _makeToken(); // так как метод асинхронный нужно указать await
    final validUser = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validUser);
    return sessionId;
  }

//функция для создания юрл
  Uri _makeUri(String path, [Map<String, dynamic>? parametrs]) {
    final uri = Uri.parse('$_host$path');
    if (parametrs != null) {
      return uri.replace(queryParameters: parametrs);
    } else {
      return uri;
    }
  }

//все эти методы приватные и используются всегда один за другим по этому
//нужен общий метод который юудет их вызывать
  Future<String> _makeToken() async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };
    final result = _get(
      '/authentication/token/new?api_key=',
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final parametrs = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };
    final result = _post('/authentication/token/validate_with_login?api_key=',
        parametrs, parser, <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    };

    final result = _post(
      '/authentication/session/new?api_key=',
      parameters,
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
      },
    );
    return result;
  }

  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['id'] as int;
      return response;
    };
    final result = _get(
      '/account',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  void _validateResponse(HttpClientResponse responce, dynamic json) {
    if (responce.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.Auth);
      } else {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }
  }

  //запрос на получение списка фильмов
  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    };
    final result = _get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  // Поиск для него подходит такая же обработка как и для популярных фильмов
  // так что будем менять и ее модель
  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    };
    final result = _get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'language': locale,
        'query': query,
        'page': page.toString(),
        'include_adult': true.toString(),
      },
    );
    return result;
  }

// параметры которые принимает фьюча написана на странице с tmdb get movie
// муви айди и язык
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    };
    final result = _get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': _apiKey,
        'language': locale,
      },
    );
    return result;
  }

//есть ли у фильма отметка мне нравится
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['favorite'] as bool;
      return response;
    };
    final result = _get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

// указываем в инам подсказку для прогера для того кокой медиа контент подставить
  Future<String> markIsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final message = jsonMap['status_message'] as String;
      print(message);
      return message;
    };
    final parametrs = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': isFavorite,
    };
    final result = _post(
        '/account/$accountId/favorite', parametrs, parser, <String, dynamic>{
      'api_key': _apiKey,
      'session_id': sessionId,
    });
    return result;
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
