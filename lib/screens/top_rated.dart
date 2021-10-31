import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TopRated extends StatefulWidget {
  const TopRated({Key? key}) : super(key: key);

  @override
  _TopRatedState createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  List MoviesList = [];
  bool isLoading = true;

  Future getMovies() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

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
             return  MovieCard(imgUrl:  MoviesList[movie]['poster_path'],
                  title: MoviesList[movie]['original_title'],
                  desc: MoviesList[movie]['overview']
                  , id:  MoviesList[movie]['id']);
            });
  }
}
