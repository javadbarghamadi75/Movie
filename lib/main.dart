import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie/pages/home_page.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.dark, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
      systemNavigationBarDividerColor:
          Colors.transparent, //Navigation bar divider color
      systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
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
      ),
      home: HomePage(title: 'Home Page'),
    );
  }
}
