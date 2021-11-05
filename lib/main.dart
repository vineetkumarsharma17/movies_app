import 'package:flutter/material.dart';
import 'package:movie_app/widgets/home_page.dart';
import 'package:provider/provider.dart';
import 'component/dark.dart';

void main() {
  runApp(myApp());
}
class myApp extends StatefulWidget {
  @override
  State<myApp> createState() => _myAppState();
}
class _myAppState extends State<myApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child:MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: HomePage(),
          ));
  }
}

// MaterialApp(
// debugShowCheckedModeBanner: false,
// title: "Bottom Navigation",
// home: HomePage());
// popular movie api
// https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed

// particular movie info by id 
// https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US

// backdrop image or detail page image 
// https://image.tmdb.org/t/p/original/lNyLSOKMMeUPr1RsL4KcRuIXwHt.jpg


// top rated movies 
// https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed