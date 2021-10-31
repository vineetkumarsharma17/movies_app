import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  int id;
  MovieDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        // clipBehavior: Clip.none,
        // fit: StackFit.loose,
        children: [
          Positioned(
            top: 0,
            left: 0,
            // bottom: 0,
            child: Image.network(
              "https://image.tmdb.org/t/p/original/lNyLSOKMMeUPr1RsL4KcRuIXwHt.jpg",
              // width: 400,
            ),
          ),

          Positioned(
            top: 0,
            bottom: 0,
            // left: 0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Image.network(
                    "https://image.tmdb.org/t/p/w342/d5NXSklXo0qyIYkgV94XAgMIckC.jpg",
                    width: 100,
                  ),
                ],
              ),
            ),
          )
          // Image.asset(
          //     "https://image.tmdb.org/t/p/w342/d5NXSklXo0qyIYkgV94XAgMIckC.jpg")
        ],
      ),
    );
  }
}
