import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieDetail extends StatefulWidget {
  int id;
  // MovieDetail({Key? key}) : super(key: key);
  MovieDetail({Key? key, required this.id}) : super(key: key);
  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  Map<String, dynamic> movie = {};
  bool loading=false;
  // var isLoading = true;

  Future getMovieDetailById() async {
    print("printiing inside the getmoviedetialfuntion");
    print(widget.id);
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.id}?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

     movie = jsonDecode(response.body);
    setState(() {
      loading=true;
    });
  }

  @override
  void initState() {
    super.initState();
    getMovieDetailById();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[600],
          // backgroundColor: Colors.transparent,
          title: loading?Text(movie['title']):Text("")),
      body:loading? SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              "https://image.tmdb.org/t/p/original${movie['backdrop_path']}",
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: Padding(
                padding: const EdgeInsets.all(70.0),
                child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ?
                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!.toDouble()
                        : null,),
              ));
              // You can use LinearProgressIndicator or CircularProgressIndicator instead
            },
          ),
          // Image.asset("assets/images/venom.jpg"),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  movie["original_title"]??"",
                  style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius:const BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        movie['genres'][0]['name']??"",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius:const BorderRadius.all(Radius.circular(15))),
                      child: Text(
                          movie['genres'][1]['name']??"",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const  SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          movie['popularity'].toString()??"",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold),
                        ),
                        const  SizedBox(
                          height: 10,
                        ),
                        const Text("Popularity")
                      ],
                    ),
                    Column(
                      children: [
                        const  Icon(
                          Icons.star,
                          color: Colors.red,
                        ),
                        const  SizedBox(
                          height: 10,
                        ),
                         Text("${movie['vote_average']}"??"")
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${movie['vote_count']}"??"",
                          style:const TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        const   SizedBox(
                          height: 10,
                        ),
                        const  Text("Vote Count")
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(
                  // height: 4.0,
                  color: Colors.black,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius:const BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.calendar_today,size: 14,color: Colors.white,),
                          ),
                          Text(
                            movie['release_date']??'',
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius:const BorderRadius.all(Radius.circular(15))),
                      child:  Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.alarm,size: 14,color: Colors.white,),
                          ),
                          Text(
                            movie['runtime'].toString()+" min",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const  Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    const  SizedBox(
                      height: 15.0,
                    ),
                    Text(movie['overview']??"")
                  ],
                )
              ],
            ),
          )
        ],
      )):const Center(child: CircularProgressIndicator(),),
    );
  }
}
