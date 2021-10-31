import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_card.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  List MoviesList = [];
  bool isLoading = true;

  Future getMovies() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

    var jsonData = jsonDecode(response.body);
    var movies = jsonData['results'];
    movies.forEach((movie) {
      setState(() {
        MoviesList.add(movie);
      });
    });

    print(MoviesList);
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    print("calling");
    getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: MoviesList.length,
            itemBuilder: (context, movie) {
              print("working.........");
              return movieCard(
                MoviesList[movie]['poster_path'],
                MoviesList[movie]['original_title'],
                MoviesList[movie]['overview'],
                MoviesList[movie]['id'],
              );
            });
  }
}
