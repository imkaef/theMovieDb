import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/inherited/provider.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_model.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:palette_generator/palette_generator.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 1;
  final movieListModel = MovieListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index)
      return; //не  будет перестраиваться так как ничего не поменялось
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TMDB'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          ExamplePaletteGenerator(),
          NotifierProvider(
            create: () => movieListModel,
            child: const MovieListWidget(),
            //указываем что виджет управляется не сам
            isManagingModel: false,
          ),
          const SerialsListWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Сериалы',
          ),
        ],
        // onTap: (value) => onSelectTab(value),
        //onTap: (index) => _selectedTab = index, правило функции тут в коде не писать выносить их отдельно
        onTap: onSelectTab,
      ),
    );
  }
}

class ExamplePaletteGenerator extends StatefulWidget {
  const ExamplePaletteGenerator({
    Key? key,
  }) : super(key: key);
  @override
  _ExamplePaletteGeneratorState createState() =>
      _ExamplePaletteGeneratorState();
}

class _ExamplePaletteGeneratorState extends State<ExamplePaletteGenerator> {
  List<Image> images = [
    Image.network(
      'https://sun1-19.userapi.com/s/v1/ig1/DQO8ENeBVPGNwCSgSLpaECuCsy781Pidg-Q-attLpaL7k_GwTrUW9pRGowhDcHTkduTJckLD.jpg?size=200x200&quality=96&crop=1,119,954,954&ava=1',
      filterQuality: FilterQuality.high,
    ),
    Image.network(
      'https://sun1-29.userapi.com/s/v1/if1/R2KrOmcll_adCk3MUo9L60Rp-L8Aa7pWIjkzER13TsrjBpatg1HJtVfyTlV4JUFm-m_ljfdY.jpg?size=200x200&quality=96&crop=107,61,1046,1046&ava=1',
      filterQuality: FilterQuality.high,
    ),
  ];

  List<PaletteColor> colors = [];
  @override
  void initState() {
    super.initState();
    // _updatePalettes();
  }

  // _updatePalettes() async {
  //   for (var image in images) {
  //     final PaletteGenerator generator =
  //         await PaletteGenerator.fromImageProvider(image.image);
  //     if (generator == null) return;
  //     colors.add(generator.lightMutedColor != null
  //         ? generator.lightMutedColor
  //         : PaletteColor(Colors.blue, 2));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: ListView(
        children: images,
      ),
    );
  }
}

class SerialsListWidget extends StatelessWidget {
  const SerialsListWidget({
    Key? key,
  }) : super(key: key);
  void onpressed(BuildContext context) {
    final provider = SessionDataProvider();
    provider.setSessionId(null);
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Text('serials'),
      onPressed: () => onpressed(context),
    ));
  }
}
