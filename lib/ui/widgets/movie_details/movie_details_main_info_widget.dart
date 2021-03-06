import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/domain/entity/movie_details_credits.dart';
import 'package:the_movie_db/ui/widgets/custom_widgets/customProgressBarWidgetScreen.dart';
import 'package:the_movie_db/use_case/movie_details_model.dart';

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
   final model = context.watch<MovieDetailsModel>();
    // final backdropPath = model?.movieDetails?.backdropPath;
    // final posterPath = model?.movieDetails?.posterPath;
    if (model.backDrop == null) return SizedBox.shrink();
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
                  Colors.black,
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
            child: model.backDrop,
            // child: backdropPath != null
            //     ? Image.network(ApiClient.imageUrl(backdropPath))
            //     : SizedBox.shrink(),
          ),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: Container(
              child: model.poster,
              // child: posterPath != null
              //     ? Image.network(ApiClient.imageUrl(posterPath))
              //     : SizedBox.shrink(),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(
                model.isFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_border_sharp,
                // color: Colors.lime,
                color: model.getColorList.vibrantColor?.color,
                size: 30,
              ),
              onPressed: () => model.onFavoriteTap(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final model = context.watch<MovieDetailsModel>();
    final title = model.movieDetails?.originalTitle;
    var year = model.movieDetails?.releaseDate?.year.toString();
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
                // color: AppColors.titleColorMovieDetail),
                color: model.getColorList.dominantColor?.bodyTextColor,
              ),
            ),
            TextSpan(
                text: year,
                style: TextStyle(
                    // color: AppColors.summaryDateMovieDetail,
                    color: model.getColorList.dominantColor?.titleTextColor,
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
    final model = context.watch<MovieDetailsModel>();
    final score = model.movieDetails?.voteAverage;
    final videos = model.movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
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
                      //freeColor: AppColors.freeLine,
                      lineWidth: 3,
                      //lineColor: AppColors.line,
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
                    color: model.getColorList.dominantColor?.bodyTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 15,
            color: Colors.grey,
          ),
          trailerKey != null
              ? TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () => model.onTrailerTap(context, trailerKey),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_right_sharp,
                        color: model.getColorList.dominantColor?.bodyTextColor,
                      ),
                      Text(
                        'Воспроизвести',
                        style: TextStyle(
                          color:
                              model.getColorList.dominantColor?.bodyTextColor,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final model = context.watch<MovieDetailsModel>();
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
        color: model.getColorList.dominantColor?.bodyTextColor ?? Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            summary.join(' '),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: model.getColorList.dominantColor?.color,
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
     final model = context.watch<MovieDetailsModel>();

    final overview = model.movieDetails?.overview ?? '';
    final tagLine = model.movieDetails?.tagline ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tagLine == ''
            ? Container()
            : Text(
                tagLine,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: model.getColorList.darkVibrantColor?.bodyTextColor,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Обзор',
            style: TextStyle(
                color: model.getColorList.darkVibrantColor?.bodyTextColor,
                fontSize: 21,
                fontWeight: FontWeight.w600),
          ),
        ),
        overview == ''
            ? SizedBox.shrink()
            : Text(
                overview,
                style: TextStyle(
                  fontSize: 16,
                  color: model.getColorList.darkVibrantColor?.bodyTextColor,
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
      final model = context.watch<MovieDetailsModel>();
    var crew = model.movieDetails?.credits.crew;

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
