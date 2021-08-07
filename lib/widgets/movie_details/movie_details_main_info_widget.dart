import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/const/app_images.dart';
import 'package:the_movie_db/widgets/customProgressBarWidgetScreen.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _TopPosterWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummeryWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: _ReviewWidget(),
        ),
      ],
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Image(image: AppImages.topHeader),
        Positioned(
          top: 20,
          left: 15,
          bottom: 20,
          child: Container(
            child: Image(image: AppImages.topHeaderSubImage),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Expanded(
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           Colors.white,
        //           Colors.transparent,
        //         ],
        //         begin: Alignment.centerLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Рик и Морти',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppColors.titleColorMovieDetail),
            ),
            TextSpan(
                text: ' (2013)',
                style: TextStyle(
                    color: AppColors.summaryDateMovieDetail,
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
          ],
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: RadialPercentWidget(
                    child: Text(
                      '88%',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                    percent: 88,
                    fillColor: AppColors.progressBarBackground,
                    freeColor: AppColors.freeLine,
                    lineWidth: 3,
                    lineColor: AppColors.line,
                  ),
                ),
                Text(
                  '''Пользовательский
счёт''',
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 15,
            color: Colors.grey,
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(Icons.arrow_right_sharp),
                Text('Воспроизвести'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.summaryMovieDetail,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Text(
          '18+ мультфильм, комедия, НФ и Фэнтези, Боевик и Приключения 22m',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.titleColorMovieDetail,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ),
    );
  }
}

class _ReviewWidget extends StatelessWidget {
  const _ReviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Зачем семья, когда есть наука?',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: AppColors.summaryDateMovieDetail,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Обзор',
            style: TextStyle(
                color: AppColors.titleColorMovieDetail,
                fontSize: 21,
                fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          'В центре сюжета — школьник по имени Морти и его дедушка Рик. Морти — самый обычный мальчик, который ничем не отличается от своих сверстников. А вот его дедуля занимается необычными научными исследованиями и зачастую полностью неадекватен. Он может в любое время дня и ночи схватить внука и отправиться вместе с ним в межпространственные приключения с помощью построенной из разного хлама летающей тарелки, которая способна перемещаться сквозь временной тоннель. Каждый раз эта парочка оказывается в самых неожиданных местах и самых нелепых ситуациях.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.titleColorMovieDetail,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dan Harmon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Создатель',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.titleColorMovieDetail,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Justin Roiland',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Создатель',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.titleColorMovieDetail,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
