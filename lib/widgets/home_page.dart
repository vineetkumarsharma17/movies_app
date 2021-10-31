import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/screens/now_playing.dart';
import 'package:movie_app/screens/top_rated.dart';
import 'package:http/http.dart' as http;

import 'movie_card.dart';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}
class _HomePageState extends State<HomePage> {
  List NowPlayingList = [],TopRatedList = [];
  List BackupNowPlayingList = [],BackupTopRatedList = [];
  bool isLoading = true;
  String query='';
  int _selectedItem = 0;
  bool is_searching=true;
  @override
  void initState() {
    super.initState();
    getNowPlayingMovies();
    getTopRatedMovies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          backgroundColor: Colors.red[600],
          title: is_searching?const Text("Movies Flix")
              :TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (query){
              if(_selectedItem==0) {
                NowPlayingList = BackupNowPlayingList;
                setState(() {
                  searchNowPlayingList(query);
                });
              }else{
                TopRatedList = BackupTopRatedList;
                setState(() {
                  searchTopRatedList(query);
                });
              }
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed:()=>setState(() {
                    NowPlayingList=BackupNowPlayingList;
                    is_searching=true;
                  })
                ),
                hintText: 'Search here...',
                border: InputBorder.none),
          ),
          actions: [
            is_searching?IconButton(
                icon: const Icon(Icons.search),
            onPressed: (){
                  setState(() {
                    // searchNowPlayingList(query);
                    is_searching=false;
                  });

            },):Text("")
          ]),
      body: Center(
        child:isLoading==true?const CircularProgressIndicator()
            :(_selectedItem==0)?nowPlaying()
            :topRated(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.red[600],
        backgroundColor: Colors.grey[900],
        // selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow), label: "Now Playing"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_outline), label: "Top Rated"),
        ],
        currentIndex: _selectedItem,
        onTap: (setValue) {
          setState(() {
            _selectedItem = setValue;
          });
        },
      ),
    );
  }
  Future getNowPlayingMovies() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'))
        .catchError((e){
          print(e);
    });
    var jsonData = jsonDecode(response.body);
    var movies = jsonData['results'];
    NowPlayingList=BackupNowPlayingList=movies;
    setState(() {
      isLoading = false;
    });
  }
  Future getTopRatedMovies() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));
    var jsonData = jsonDecode(response.body);
    var movies = jsonData['results'];
    TopRatedList=BackupTopRatedList=movies;
    setState(() {
      isLoading = false;
    });
  }
  void searchNowPlayingList(String query){
    List searchData=[];
    for(Map x in NowPlayingList){
      if(x["title"].toString().toLowerCase().startsWith(query.toLowerCase())) {
        //print(x["title"]);
        searchData.add(x);
      }
      setState(() {
        NowPlayingList=searchData;
      });
    }
    if(searchData.isEmpty) {
      Fluttertoast.showToast(
        msg: "Movie not found!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    // print(searchData);
  }
  void searchTopRatedList(String query){
    List searchData=[];
    for(Map x in TopRatedList){
      if(x["title"].toString().toLowerCase().startsWith(query.toLowerCase())) {
        //print(x["title"]);
        searchData.add(x);
      }
      setState(() {
        TopRatedList=searchData;
      });
    }
    if(searchData.isEmpty) {
      Fluttertoast.showToast(
        msg: "Movie not found!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    // print(searchData);
  }
  Widget nowPlaying()=> ListView.builder(
      itemCount: NowPlayingList.length,
      itemBuilder: (context, movie) {
        return MovieCard(imgUrl:  NowPlayingList[movie]['poster_path'],
            title: NowPlayingList[movie]['original_title'],
            desc: NowPlayingList[movie]['overview']
            , id:  NowPlayingList[movie]['id']);
      });
  Widget topRated()=>ListView.builder(
      itemCount: TopRatedList.length,
      itemBuilder: (context, movie) {
        return  MovieCard(imgUrl:  TopRatedList[movie]['poster_path'],
            title: TopRatedList[movie]['original_title'],
            desc: TopRatedList[movie]['overview']
            , id:  TopRatedList[movie]['id']);
      });
}
