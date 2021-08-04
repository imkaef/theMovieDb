import 'package:flutter/material.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 18,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Image(
              image: AssetImage('assets/goodFather.jpg'),
            ),
          ],
        );
      },
    );
  }
}
