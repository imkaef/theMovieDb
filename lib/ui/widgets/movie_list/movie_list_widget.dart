import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/inherited/provider.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_model.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<MovieListModel>(context);
    if (model == null) return SizedBox.shrink();
    return Stack(
      children: [
        ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(top: 76),
          itemCount: model.movies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = model.movies[index];
            //делаем картинки
            final posterPath = movie.posterPath;
            //fix date
            final movieRealiseDate = movie.releaseDate;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.3,
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
                          posterPath != null
                              ? Image.network(
                                  ApiClient.imageUrl(posterPath),
                                  width: 95,
                                )
                              : SizedBox.shrink(),
                          //  Image(image: movie.imageName),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    model.stringFromDate(movie.releaseDate),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    movie.overview,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.3),
                      borderRadius: _MBR.custom,
                      //Добавляем этот метод в модель
                      onTap: () => model.onMovieTap(context, index),
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
