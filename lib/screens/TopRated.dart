import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/widgets/movie_card.dart';
class TopRatedPage extends StatefulWidget {
  final List data;
  const TopRatedPage({Key? key,required this.data}) : super(key: key);
  @override
  _TopRatedPageState createState() => _TopRatedPageState(data);
}

class _TopRatedPageState extends State<TopRatedPage> {
  List TopRatedList=[],BackupTopRatedList;
  _TopRatedPageState(this.BackupTopRatedList);
  bool is_searching=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
            backgroundColor: Colors.red[600],
            title: is_searching?const Text("Top Rated Movies")
                :TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (query){
                TopRatedList=BackupTopRatedList;
                setState(() {
                 searchNowPlayingList(query);
                });
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed:()=>setState(() {
                        TopRatedList=BackupTopRatedList;
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
      body: ListView.builder(
          itemCount: TopRatedList.length,
          itemBuilder: (context, movie) {
            return MovieCard(imgUrl:  TopRatedList[movie]['poster_path'],
                title: TopRatedList[movie]['original_title'],
                desc: TopRatedList[movie]['overview']
                , id:  TopRatedList[movie]['id']);
          }),
    
    );
  }
  void searchNowPlayingList(String query){
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
}
