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
  Map<String, dynamic> Movie = {};

  Future getMovieDetailById() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.id}?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

    var jsonData = jsonDecode(response.body);
    print(jsonData);
    // var movies = jsonData['results'];
    // movies.forEach((movie) {
    setState(() {
      Movie = jsonData;
    });
    // });

    print(Movie);
    // isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    print("calling");
    getMovieDetailById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: Text("Venom"),backgroundColor: Colors.red[600],
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                  "https://image.tmdb.org/t/p/original${Movie['backdrop_path']}"),
              // Image.asset("assets/images/venom.jpg"),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Text(Movie['original_title']),
                    Text(
                      Movie['original_title'],
                      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Text(
                            Movie['genres'][0]['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Text(
                            "Action",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("13456",
                              // Movie['popularity'],
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Popularity")
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("")
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "123456",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Vote Count")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      // height: 4.0,
                      color: Colors.black,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                            "Minutes after Laurie Strode, her daughter Karen and granddaughter Allyson left masked monster Michael Myers caged and burning in Laurie's basement, Laurie is rushed to the hospital with life-threatening injuries, believing she finally killed her lifelong tormentor. But when Michael manages to free himself from Laurie's trap, his ritual bloodbath resumes. As Laurie fights her pain and prepares to defend herself against him, she inspires all of Haddonfield to rise up against their unstoppable monster. The Strode women join a group of other survivors of Michael's first rampage who decide to take ")
                      ],
                    )
                  ],
                ),
              )
              // Expanded(
              //     child: Text(
              //         "Minutes after Laurie Strode, her daughter Karen and granddaughter Allyson left masked monster Michael Myers caged and burning in Laurie's basement, Laurie is rushed to the hospital with life-threatening injuries, believing she finally killed her lifelong tormentor. But when Michael manages to free himself from Laurie's trap, his ritual bloodbath resumes. As Laurie fights her pain and prepares to defend herself against him, she inspires all of Haddonfield to rise up against their unstoppable monster. The Strode women join a group of other survivors of Michael's first rampage who decide to take matters into their own hands, "))

              // Text(Movie['release_date']),
              // Text(Movie['spoken_languages'][0]['name']),
              // Text("Rating ${Movie['vote_average']}"),
              // Text(Movie['overview']),
            ],
          )),
    );
  }
}