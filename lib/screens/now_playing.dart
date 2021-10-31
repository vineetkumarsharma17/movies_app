import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_card.dart';

class NowPlaying extends StatefulWidget {
 final List MoviesList;
  const NowPlaying({Key? key,required this.MoviesList}) : super(key: key);
  @override
  _NowPlayingState createState() => _NowPlayingState(MoviesList);
}
class _NowPlayingState extends State<NowPlaying> {
  final List MoviesList;
  _NowPlayingState(this.MoviesList);

  @override
  // void initState() {
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
            itemCount: MoviesList.length,
            itemBuilder: (context, movie) {
              return MovieCard(imgUrl:  MoviesList[movie]['poster_path'],
                  title: MoviesList[movie]['original_title'],
                  desc: MoviesList[movie]['overview']
                  , id:  MoviesList[movie]['id']);
            });
  }
}
