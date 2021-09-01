import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/domain/entity/movie_details_credits.dart';
import 'package:the_movie_db/domain/inherited/provider.dart';
import 'package:the_movie_db/ui/widgets/customProgressBarWidgetScreen.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_model.dart';

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
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    // final backdropPath = model?.movieDetails?.backdropPath;
    // final posterPath = model?.movieDetails?.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 220,
      //аспект ратио нужен чтобы установить соотношение с которым будет
      //отображаться постер большоq
      //на меньшем экране юудет тоже ментше
      child: Stack(
        //  fit: StackFit.loose,
        children: [
          ShaderMask(
            //добавление краски на топ изображение фильма
            shaderCallback: (rect) {
              return LinearGradient(
                colors: [
                  AppColors.blackBackgroundMovieDetail,
                  Colors.transparent,
                ],
                stops: [0.5, 0.8],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(
                Rect.fromLTRB(rect.width, rect.height, 0, 0),
              );
            },
            blendMode: BlendMode.dstIn,
            child: model?.backDrop,
            // child: backdropPath != null
            //     ? Image.network(ApiClient.imageUrl(backdropPath))
            //     : SizedBox.shrink(),
          ),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: Container(
              child: model?.poster,
              // child: posterPath != null
              //     ? Image.network(ApiClient.imageUrl(posterPath))
              //     : SizedBox.shrink(),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinearGradientWidget extends StatelessWidget {
  const LinearGradientWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blackBackgroundMovieDetail,
            Colors.transparent,
          ],
          stops: [0.2, 0.7],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    final title = model?.movieDetails?.originalTitle;
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : 'Неизвестный год';
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppColors.titleColorMovieDetail),
            ),
            TextSpan(
                text: year,
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
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    final score = model?.movieDetails?.voteAverage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {},
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: RadialPercentWidget(
                      child: Text(
                        score != null
                            ? '${(10 * score).toInt().toString()}%'
                            : '',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      percent: score != null ? score * 10 : 88,
                      fillColor: AppColors.progressBarBackground,
                      freeColor: AppColors.freeLine,
                      lineWidth: 3,
                      lineColor: AppColors.line,
                    ),
                  ),
                ),
                Text(
                  '''Пользовательский
счёт''',
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
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
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    //собираем массив из слов которые надо вписать
    var summary = <String>[];
    // записываем в массив дату когда был выпущен фильм
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      // переводим дату в стрингу и записываем в массив метод превода такой же
      // как в муви лист модал
      summary.add(model.stringFromDate(releaseDate));
    }
    // собираем страны на которых есть
    final productionCountries = model.movieDetails?.productionCountries;
    // если массив не нал и не пуст добвляем элементы
    if (productionCountries != null && productionCountries.isNotEmpty) {
      summary.add(productionCountries.first.iso);
      // summary.add('(${productionCountries.first.iso})');
    }
    // Продолжительность фильма тут парсим его в часы из минут
    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    summary.add('${hours}h ${minutes}m');
    // Массив жанров в которых представлен фильм
    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      summary.add(genresNames.join(', '));
    }

    return Center(
      child: ColoredBox(
        color: const Color.fromRGBO(22, 21, 25, 1.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            summary.join(' '),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewWidget extends StatelessWidget {
  const _ReviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);

    final overview = model?.movieDetails?.overview ?? '';
    final tagLine = model?.movieDetails?.tagline ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tagLine,
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
          overview,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.titleColorMovieDetail,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: _DirectorWidget(),
        )
      ],
    );
  }
}

class _DirectorWidget extends StatelessWidget {
  const _DirectorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);

    var crew = model?.movieDetails?.credits.crew;

    //эта штука дает понять что дальше в коде модель точно не нал
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    //сабЛист это подмоссив из основного массива
    //проверка на количество крю в массиве
    crew.sort((a, b) => b.popularity.compareTo(a.popularity));
    // for (var cr in crew) {
    //   print(cr.popularity);
    // }
    if (crew.length > 4) crew = crew.sublist(0, 4);
    final crewWidget = crew
        .map((employee) => EmployeeWidget(
              employee: employee,
            ))
        .toList();
    return SizedBox.shrink();
    // return GridView.count(
    //   crossAxisCount: 2,
    //   children: crewWidget,
    // );
    // return SizedBox(
    //   height: 100,
    //   width: double.infinity,
    //   child: Wrap(
    //     direction: Axis.horizontal,
    //     children: crewWidget,
    //   ),
    // );
    // return SizedBox(
    //   width: double.infinity,
    //   child: Row(
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: crewWidget,
    //       ),
    //     ],
    //   ),
    // );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       children: [
    //         Column(
    //           children: [
    //             Text(
    //               'Justin Roiland',
    //               style: TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.w700,
    //               ),
    //             ),
    //             Text(
    //               'Создатель',
    //               style: TextStyle(
    //                 fontSize: 16,
    //                 color: AppColors.titleColorMovieDetail,
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}

class EmployeeWidget extends StatelessWidget {
  //const
  EmployeeWidget({
    Key? key,
    required this.employee,
  }) : super(key: key);

  final Employee employee;
  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    final creatorStyle = TextStyle(
      fontSize: 14,
      color: AppColors.titleColorMovieDetail,
    );
    return
        // Container(
        //   color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        //   child:
        Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.job,
            overflow: TextOverflow.ellipsis,
            style: creatorStyle,
          ),
          Text(
            employee.name,
            style: nameStyle,
          )
        ],
        // ),
      ),
    );
  }
}
