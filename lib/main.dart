import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie/pages/new_home_page%20copy%203.dart';
import 'package:movie/pages/new_home_page%20copy%204.dart';
import 'package:movie/pages/new_home_page%20copy%205.dart';
import 'package:movie/pages/new_home_page%20copy%206.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[900], // navigation bar color
      statusBarColor: Colors.grey[900], // status bar color
      statusBarBrightness: Brightness.light, //status bar brightness
      statusBarIconBrightness: Brightness.light, //status barIcon Brightness
      systemNavigationBarDividerColor:
          Colors.grey[900], //Navigation bar divider color
      systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The MovieDB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Comfortaa',
        textTheme: TextTheme(
          subtitle1: TextStyle(textBaseline: TextBaseline.alphabetic),
        ),
        unselectedWidgetColor: Colors.white60,
      ),
      home: NewHomePageCopy6(title: 'Home Page'),
    );
  }
}
