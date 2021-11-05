import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/component/dark.dart';
import 'package:movie_app/component/show_dilog.dart';
import 'package:provider/provider.dart';

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
  TextEditingController searchController=TextEditingController();
  String query='';
  bool dark=false;
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
            controller:searchController ,
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
                  onPressed:(){
                    if(_selectedItem==0) {
                      NowPlayingList = BackupNowPlayingList;
                      setState(() {
                        searchController.clear();
                        is_searching=true;
                      });
                    }else{
                      TopRatedList = BackupTopRatedList;
                      setState(() {
                        searchController.clear();
                        is_searching=true;
                      });
                    }
                  }
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     final themeChange = Provider.of<DarkThemeProvider>(context,listen: false);
      //     setState(() {
      //       themeChange.darkTheme = !dark;
      //     });
      //   },
      //  // child: Icon(CupertinoIcons.plus),
      // ),
    );
  }
  Future getNowPlayingMovies() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'))
        .catchError((e){
          String error= e.osError.toString();
      if(e is SocketException)
       error="No Internet connection";
      if(e is TimeoutException)
        error="Connection timeout";
      dilogHelper.showMyDialog("Error!", error, context);
          setState(() {
            isLoading = false;
          });
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
        'https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed')
    ).catchError((e){
      setState(() {
        isLoading = false;
      });
      print(e);
    });
    var jsonData = jsonDecode(response.body);
    var movies = jsonData['results'];
    TopRatedList=BackupTopRatedList=movies;
    setState(() {
      isLoading = false;
    });
  }
  void searchNowPlayingList(String query){
    List  searchData=[];
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
  Widget nowPlaying()=> RefreshIndicator(onRefresh: getNowPlayingMovies,
    child: ListView.builder(
        itemCount: NowPlayingList.length,
        itemBuilder: (context, index) {
          final item = NowPlayingList[index]["title"].toString();
          return Dismissible(
            key: Key(item),
            onDismissed: (direction){
              setState(() {
                NowPlayingList.removeAt(index);
                Fluttertoast.showToast(
                  msg: "$item dismissed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              });
            },
            background: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child: Icon(Icons.delete,color: Colors.white,),
            ),
            child: MovieCard(imgUrl:  NowPlayingList[index]['poster_path'],
                title: NowPlayingList[index]['title'],
                desc: NowPlayingList[index]['overview']
                , id:  NowPlayingList[index]['id']),
          );
        }),
  );
  Widget topRated()=>RefreshIndicator(onRefresh: getTopRatedMovies,
    child: ListView.builder(
        itemCount: TopRatedList.length,
        itemBuilder: (context, index) {
          final item = TopRatedList[index]["title"].toString();
          return  Dismissible(
            key: Key(item),
            onDismissed: (direction){
              setState(() {
                TopRatedList.removeAt(index);
                Fluttertoast.showToast(
                  msg: "$item dismissed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              });
            },
            background: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child: Icon(Icons.delete,color: Colors.white,),
            ),
            child: MovieCard(imgUrl:  TopRatedList[index]['poster_path'],
                title: TopRatedList[index]['title'],
                desc: TopRatedList[index]['overview']
                , id:  TopRatedList[index]['id']),
          );
        }),
  );
  // Widget deleteBg()=>Container(
  //   alignment: Alignment.centerRight,
  //   padding: EdgeInsets.only(right: 20),
  //   color: Colors.red,
  //   child: Icon(Icons.delete,color: Colors.white,),
  // );
}
