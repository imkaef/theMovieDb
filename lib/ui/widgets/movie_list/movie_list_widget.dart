import 'package:flutter/material.dart';
import 'package:the_movie_db/const/app_images.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class Movie {
  final int id;
  final AssetImage imageName;
  final String title;
  final String time;
  final String description;
  Movie({
    required this.id,
    required this.imageName,
    required this.title,
    required this.time,
    required this.description,
  });
}

// class Movie {
//   final AssetImage imageName;
//   final String title;
//   final String time;
//   final String description;
//   Movie(
//     this.imageName,
//     this.title,
//     this.time,
//     this.description,
//   );
// }

class MovieListWidget extends StatefulWidget {
  MovieListWidget({Key? key}) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void initState() {
    _filteredMovies = _movies;
    super.initState();
    _searchController.addListener(_searchMovies);
  }

  void _searchMovies() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _filteredMovies = _movies.where((Movie movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredMovies = _movies;
    }
    setState(() {});
  }

  var _filteredMovies = <Movie>[];

  final _searchController = TextEditingController();

  final _movies = [
    Movie(
      id: 1,
      imageName: AppImages.moviePlaceHolder,
      title: 'Смертельная битва',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 2,
      imageName: AppImages.moviePlaceHolder,
      title: 'Прибытие',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 3,
      imageName: AppImages.moviePlaceHolder,
      title: 'Назад в будущее 1',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 4,
      imageName: AppImages.moviePlaceHolder,
      title: 'Назад в будущее 2',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 5,
      imageName: AppImages.moviePlaceHolder,
      title: 'Назад в будущее 3',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 6,
      imageName: AppImages.moviePlaceHolder,
      title: 'Первому игроку приготовится',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 7,
      imageName: AppImages.moviePlaceHolder,
      title: 'Пиксели',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 8,
      imageName: AppImages.moviePlaceHolder,
      title: 'Человек паук',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 9,
      imageName: AppImages.moviePlaceHolder,
      title: 'Лига справедливости',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 10,
      imageName: AppImages.moviePlaceHolder,
      title: 'Человек из стали',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 11,
      imageName: AppImages.moviePlaceHolder,
      title: 'Мстители',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 12,
      imageName: AppImages.moviePlaceHolder,
      title: 'Форд против феррари',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 13,
      imageName: AppImages.moviePlaceHolder,
      title: 'Джентельмены',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 14,
      imageName: AppImages.moviePlaceHolder,
      title: 'Тихие зори',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 15,
      imageName: AppImages.moviePlaceHolder,
      title: 'В бой идут одни старики',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      id: 16,
      imageName: AppImages.moviePlaceHolder,
      title: 'Дюна',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
  ];

  void _onMovieTap(int index) {
    //final id = _filteredMovies[index].id;
    final id = _filteredMovies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id, //сами контролируем какие параметры передаем
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(top: 76),
          itemCount: _filteredMovies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = _filteredMovies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                        borderRadius: _MBR.custom,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        Image(
                          image: movie.imageName,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                movie.time,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                movie.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.3),
                      borderRadius: _MBR.custom,
                      onTap: () => _onMovieTap(index),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                fillColor: Colors.white.withAlpha(220),
                border: OutlineInputBorder(borderRadius: _MBR.custom)),
          ),
        )
      ],
    );
  }
}

// класс для бордер радиусов у виджетов
abstract class _MBR {
  // ignore: unused_field
  static const sml = 10.0;
  static const mdm = 15.0;
  // ignore: unused_field
  static const lrg = 20.0;
  static const custom = BorderRadius.all(Radius.circular(mdm));
}
