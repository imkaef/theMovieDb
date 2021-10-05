import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:the_movie_db/ui/widgets/news_screen/news_screen_widget.dart';
import 'package:the_movie_db/ui/widgets/serials_screen/serials_screen_widget.dart';
import 'package:the_movie_db/use_case/inherited/provider.dart';
import 'package:the_movie_db/use_case/movie_list_model.dart';

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
          NewsScreenWidget(),
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
