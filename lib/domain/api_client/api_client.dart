import 'dart:convert';
import 'dart:io';

// перечисление ошибок
enum ApiClientExceptionType { Network, Auth, Other }

//Создаем класс ошибок для этого имплементируем класс Exception
// Всего определили 3 типа ошибок Сервер, сеть на устройстве, ошибки с сервера не верный логин или пароль
class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host =
      'https://api.themoviedb.org/3'; //куда мы юудем отправлять запросы все запросы начинаются с этого урл
  // static const _imageUrl =
  //     'https://image.tmdb.org/t/p/w500'; // если нужны картинки они лежат тут
  static const _apiKey =
      '5eb1af50a385519917194d83bbebfab3'; // апи кей этот ключ в личном кабинете с помощью него можно работать с прогой
  // надо сделать 3 запроса мэйк токен
  // валидате юзер
  // make session

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
    final url =
        _makeUri('/authentication/token/new?api_key=', {'api_key': _apiKey});
    //  final url = Uri.parse('$_host/authentication/token/new?api_key=$_apiKey');

// начало обраюботок ошибок
    try {
      // если гдето тут будет ошибка то мы попадаем сюда
      final request = await _client.getUrl(url);
      final responce = await request.close();
      if (responce.statusCode == 401)
        throw ApiClientException(ApiClientExceptionType.Other);
      final json = (await responce.jsonDecode()) as Map<String, dynamic>;
      final token = json['request_token'] as String;
      return token;
      // Вот сюда
    } on SocketException {
      // Если ошибка с сетью мы генерируем ощибку и выходим
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      // Ессли получаем нашу ощибку описанную через if то мы её просто пробрасываем наверх
      rethrow;
    } catch (_) {
      // и если случилось что не наша и не сокет то это другие ошибки
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    try {
      final url = _makeUri('/authentication/token/validate_with_login?api_key=',
          {'api_key': _apiKey});
      final parameters = <String, dynamic>{
        'username': username,
        'password': password,
        'request_token': requestToken,
      };
      final request = await _client.postUrl(
        url,
      );
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final responce = await request.close();
      final json = (await responce.jsonDecode()) as Map<String, dynamic>;
      if (responce.statusCode == 401) {
        final dynamic status = json['statusCode'];
        final code = status is int ? status : 0;
        if (code == 30) {
          throw ApiClientException(ApiClientExceptionType.Auth);
        } else {
          throw ApiClientException(ApiClientExceptionType.Other);
        }
      }
      final token = json['request_token'] as String;
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    try {
      final url = _makeUri(
          '/authentication/session/new?api_key=', {'api_key': _apiKey});
      // final url = Uri.parse('$_host/authentication/session/new?api_key=$_apiKey');
      final parameters = <String, dynamic>{
        'request_token': requestToken,
      };
      final request = await _client.postUrl(
        url,
      );
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final responce = await request.close();
      final json = (await responce.jsonDecode()) as Map<String, dynamic>;
      // final json = await responce заменяем это на то что написанно вверху, этот метод описан внизу
      //     .transform(utf8.decoder)
      //     .toList()
      //     .then((value) => value.join())
      //     .then((v) => jsonDecode(v) as Map<String, dynamic>);
      if (responce.statusCode == 401) {
        final dynamic status = json['statusCode'];
        final code = status is int ? status : 0;
        if (code == 30) {
          throw ApiClientException(ApiClientExceptionType.Auth);
        } else {
          throw ApiClientException(ApiClientExceptionType.Other);
        }
      }
      final sessionId = json['session_id'] as String;
      return sessionId;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
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
