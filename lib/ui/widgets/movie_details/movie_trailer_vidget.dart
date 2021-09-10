import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//получили треллер добавили в запрос в муви детаилс запрос видео
// Добавили этот теш в апи клиент
// Создали модель для данных которые приходят из сети 
//  В мэйн виджет вытащили все ссылки на видео только ютуба 
// Убедились чо там есть видео смотрим самое первое у него берем Ключ далее получаем по ключу 
// если ключ есть то рисуем кнопку плэй треллер
// добавили стейт фулл виджет потом добавили подключение библеотеки для ютуба 
// И сделал навигацию 
class MovieTrailerWidget extends StatefulWidget {
  final String youTubeKey;
  MovieTrailerWidget({Key? key, required this.youTubeKey}) : super(key: key);

  @override
  _MovieTrailerWidgetState createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youTubeKey,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
    return YoutubePlayerBuilder(
      player: player,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Trailer'),
          ),
          body: Center(
            child: player,
          ),
        );
      },
    );
  }
}
