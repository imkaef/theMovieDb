import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_screen_cast_widget.dart';
import 'package:the_movie_db/use_case/movie_details_model.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);
  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    //получаем нашу модель и выполняем сетап локаль итаким
    //образом настраиваем локаль и подписываемся на измениние локали
    super.didChangeDependencies();
    // NotifierProvider.readFromModel<MovieDetailsModel>(context)
    //     ?.setupLocale(context);
    context.watch<MovieDetailsModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //если это не сделать
        title: const _TitleWidget(),
      ),
      // убираем боди в отдельный виджет для того чтобы не отображалист даннные
      // пока идет загрузка экрана
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    // final movieDetails = model?.movieDetails;
    // if (model?.backDrop == null || model?.getColor == null)
    // return SizedBox.shrink();
    if (model.isloading == true || model.getColorList == null)
      return Center(
        child: model.errorMessage != null
            ? const CircularProgressIndicator()
            : _ErrorMessageWidget(),
      );
    return ColoredBox(
      color: model.getColorList != null
          ? model.getColorList.dominantColor!.color
          : Colors.white,
      child: RefreshIndicator(
        child: ListView(
          children: [
            const _ErrorMessageWidget(),
            const MovieDetailsMainInfoWidget(),
            const MovieDetailsMainScreenCastWidget(),
          ],
        ),
        onRefresh: () => model.refresh(context),
      ),
    );
  }
}

// этот виджет должен быть внизу так как при изменении
// его в дереве оно всё перестроится а это не надо
class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key? key,
  }) : super(key: key);
// и это как только моделька меняется меняется весь экран
// а так как виджет перенесен отдельно аппбар и скаффолд перезагружаться не Будут
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return Text(model.movieDetails?.title ?? 'Загрузка...');
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.watch<MovieDetailsModel>().errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Center(
      child:
          Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 17)),
    );
  }
}
