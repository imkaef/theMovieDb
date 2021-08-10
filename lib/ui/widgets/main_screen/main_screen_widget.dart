import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';
import '../customProgressBarWidgetScreen.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 1;
  void onSelectTab(int index) {
    if (_selectedTab == index)
      return; //не  будет перестраиваться так как ничего не поменялось
    setState(() {
      _selectedTab = index;
    });
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
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.yellow, Colors.green])),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                child: RadialPercentWidget(
                  child: Text('news'),
                  fillColor: Colors.green.shade300,
                  freeColor: Colors.grey,
                  lineColor: Colors.purple,
                  lineWidth: 7,
                  percent: 24,
                ),
              ),
            ),
          ),
          MovieListWidget(),
          Text('serials'),
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
